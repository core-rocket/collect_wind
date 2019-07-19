#!/usr/bin/ruby
require 'parallel'

CONF = {
	"surf" => {	"lat" => {	"min" => 120, "max" => 150,
							"res" => 0.0625,  "num" => 481 },
				"lng" => {	"min" => 22.4, "max" => 47.6,
			   				"res" => 0.05, "num" => 505 } },
	"pall" => {	"lat" => {	"min" => 120, "max" => 150,
							"res" => 0.0125, "num" => 241 },
				"lng" => {	"min" => 22.4, "max" => 47.6,
							"res" => 0.1, "num" => 253 } }
}

def calc_fpos(model, lat, lng)
	c = CONF[model]
	latnum = ((lat - c["lat"]["min"]) / c["lat"]["res"]).to_i
	lngnum = ((lng - c["lng"]["min"]) / c["lng"]["res"]).to_i
	bnum = latnum + (c["lat"]["num"] * lngnum)
	return bnum * 4
end

if ARGV.size() == 0 then
	fname=`ls download/*.bin`.split
	fnum = fname.length - 1
	puts "downloaded file number = #{fnum}"

	`mkdir -f data`
	Parallel.each([*0..fnum], progress: "extract data to direct access binary format"){|n|
		f = fname[n].sub(/download\//, "")
		f = f.sub(/\.bin$/, "")
		f = "data/" + f + "_1.dat"
		`wgrib2 #{fname[n]} -d 1 -no_header -ieee #{f}`
	}
end
