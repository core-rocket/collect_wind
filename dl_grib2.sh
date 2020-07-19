#!/bin/bash

# sample url: http://database.rish.kyoto-u.ac.jp/arch/jmadata/data/gpv/original/2017/08/10/Z__C_RJTD_20170810060000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin

url_base="http://database.rish.kyoto-u.ac.jp/arch/jmadata/data/gpv/original"
fname_1="Z__C_RJTD_"
fname_2=_"MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin"

# デフォルト設定
dl_dir="download/"

year=2019
month=9
day=1
start_day=1
end_day=31

hour=6
start_hour=6
end_hour=9
min=0
sec=0

usage(){
	echo "Usage: $0 [OPTIONS]" 1>&2
	echo "download grib2 binary data from RISH database"
	echo "  RISH: Research Institute for Sustainable Humanosphere)"
	echo -e "Options:
  -d\tdownload directory
  -y\tyear
  -m\tmonth
  -s\tstart day
  -e\tend day
  -h\tprint this mesage
  -v\tprint version"
}

version(){
	echo "$(basename $0) 0.2"
	echo "Copyright (C) 2019 Challengers Of Rocket Engineering"
	echo -e "\nWritten by sksat <sksat@sksat.net>"
}

parse_opt(){
	while getopts d:hv OPT
	do
		case $OPT in
			d ) dl_dir=$OPTARG;;
			h ) usage
				exit 0 ;;
			v ) version
				exit 0 ;;
		esac
	done
	shift $((OPTIND - 1))
	year=$1
	month=$2
	start_day=$3
	end_day=$4
	start_hour=$5
	end_hour=$6
}

download_data(){
	t=`printf "%d%02d%02d%02d%02d%02d" $year $month $day $hour $min $sec`
	fname=$fname_1$t$fname_2
	url=$url_base/$date/$fname
	wget -q -c -P $dl_dir $url
}

dl_grib2(){
	if [ ! -d $dl_dir ]; then
		mkdir -p $dl_dir
	fi
	for ((day=$start_day; $day <= $end_day; day++)){
		date=`printf "%d/%02d/%02d" $year $month $day`
		echo -n "downloading $date data "
		for (( hour=$start_hour; $hour <= $end_hour; hour++ )) {
			download_data
			echo -n "."
		}
		echo " [ok]"
	}
}

default(){
	month=9
	start_day=14
	end_day=20
	start_hour=6
	end_hour=9
	for ((year=2017; $year <= 2019; year++)) {
		dl_grib2
	}
}

if [ $# = 0 ];then
	default
	exit 0
fi

parse_opt
dl_grib2
