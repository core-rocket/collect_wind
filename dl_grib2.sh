#!/bin/bash

# sample url: http://database.rish.kyoto-u.ac.jp/arch/jmadata/data/gpv/original/2017/08/10/Z__C_RJTD_20170810060000_MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin

url_base="http://database.rish.kyoto-u.ac.jp/arch/jmadata/data/gpv/original"
fname_1="Z__C_RJTD_"
fname_2=_"MSM_GPV_Rjp_L-pall_FH00-15_grib2.bin"

# デフォルト設定
dl_dir="data/"

year=2017
month=8
start_day=1
end_day=31

hour=6
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
	echo "$(basename $0) 0.1"
	echo "Copyright (C) 2019 Challengers Of Rocket Engineering"
	echo -e "\nWritten by sksat <sksat@sksat.net>"
}

while getopts d:y:m:s:e:hv OPT
do
	case $OPT in
		d ) dl_dir=$OPTARG;;
		y ) year=$OPTARG;;
		m ) month=$OPTARG;;
		s ) start_day=$OPTARG;;
		e ) end_day=$OPTARG;;
		h ) usage
			exit 0 ;;
		v ) version
			exit 0 ;;
	esac
done

if [ ! -d $dl_dir ];then
	mkdir -p $dl_dir
fi

for ((day=$start_day; $day <= $end_day; day++)); do
	t=$(printf "%d%02d%02d%02d%02d%02d" $year $month $day $hour $min $sec)
	date=$(printf %d/%02d/%02d $year $month $day)
	fname=$fname_1$t$fname_2
	url=$url_base/$date/$fname
	echo -n "downloading $date data..."
	wget -q -c -P $dl_dir $url
	echo "[ok]"
done
