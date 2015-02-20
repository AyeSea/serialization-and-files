require 'csv'
require 'sunlight/congress'
require 'erb'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
	zipcode.to_s.rjust(5, "0")[0..4]
end


def clean_phone(homephone)
	homephone.gsub!(/\D/, "")

	if homephone.length == 10
		homephone
	elsif homephone.length == 11 && homephone[0] == "1"
		homephone[1..10]
	else
		badphone
	end
end


def badphone
	"0" * 10
end


def find_hour(regdate)
	date_and_time(regdate).hour
end


def find_day(regdate)
	date_and_time(regdate).wday
end


def date_and_time(regdate)
	DateTime.strptime(regdate, "%m/%d/%Y %H:%M")
end


def legislators_by_zipcode(zipcode)
	Sunlight::Congress::Legislator.by_zipcode(zipcode)
end


def save_thank_you_letters(id, form_letter)
	Dir.mkdir("output") unless Dir.exists?("output")

	filename = "output/thanks_#{id}.html"

	File.open(filename, "w") do |file|
		file.puts form_letter
	end
end


def find_most_freq(item_array, item_hash)
	find_freqs(item_array, item_hash)
	max_freq = item_hash.values.sort.last
	most_repeats = []

	item_hash.each do |item, freq|
		most_repeats << item if item_hash[item] == max_freq
	end

	most_repeats
end


def find_freqs(item_array, item_hash)
	item_array.each do |item|
		if item_hash.include?(item)
			item_hash[item] += 1
		else
			item_hash[item] = 1
		end
	end
end


puts "EventManager initialized."
contents = CSV.open("event_attendees.csv", headers: true, header_converters: :symbol)

template_letter = File.read("form_letter.erb")
erb_template = ERB.new(template_letter)

registered_hours = []
registered_days = []

contents.each do |row|
	id = row[0]
	name = row[:first_name]
	phone = clean_phone(row[:homephone])
	zipcode = clean_zipcode(row[:zipcode])
	legislators = legislators_by_zipcode(zipcode)

	registered_hour = find_hour(row[:regdate])
	registered_hours << registered_hour

	registered_day = find_day(row[:regdate])
	registered_days << registered_day

	form_letter = erb_template.result(binding)

	save_thank_you_letters(id, form_letter)
end

hours_and_freq = {}
days_and_freq = {}
most_freq_hours = find_most_freq(registered_hours, hours_and_freq).join(", ")
most_freq_days = find_most_freq(registered_days, days_and_freq).join(", ")

puts "Peak Registration Hour(s): #{most_freq_hours}"
puts "Peak Registration Day(s): #{most_freq_days}"