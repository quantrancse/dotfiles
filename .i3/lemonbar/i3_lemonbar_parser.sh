#!/bin/bash
#
# Input parser for i3 bar
# 14 ago 2015 - Electro7

# config
. $(dirname $0)/i3_lemonbar_config

# min init
irc_n_high=0
title="%{F${color_head} B${color_sec_b2}}${sep_right}%{F${color_head} B${color_sec_b2}%{T2} ${icon_prog} %{F${color_sec_b2} B-}${sep_right}%{F- B- T1}"

# parser
while read -r line ; do
  case $line in
    SYS*)
      # conky=, 0 = wday, 1 = mday, 2 = month, 3 = time, 4 = cpu, 5 = mem, 6 = disk /, 7 = disk /home, 8-9 = up/down wlan, 10-11 = up/down eth, 12-13=speed
      sys_arr=(${line#???})
      # date
      if [ ${res_w} -gt 1024 ]; then
        date="${sys_arr[0]} ${sys_arr[1]} ${sys_arr[2]}"
      else
        date="${sys_arr[1]} ${sys_arr[2]}"
      fi
      date="%{F${color_icon}}${sep_l_left}%{F${color_icon} B${color_sec_b1}} %{T2}${icon_clock}%{F- T1} ${date}"
      # time
      time="%{F${color_head}}${sep_left}%{F${color_back} B${color_head}} ${sys_arr[3]} %{F- B-}"
      # cpu
      if [ ${sys_arr[4]} -gt ${cpu_alert} ]; then
        cpu_cback=${color_cpu}; cpu_cicon=${color_back}; cpu_cfore=${color_back};
      else
        cpu_cback=${color_sec_b2}; cpu_cicon=${color_icon}; cpu_cfore=${color_fore};
      fi
      cpu="%{F${cpu_cback}}${sep_left}%{F${cpu_cicon} B${cpu_cback}} %{T2}${icon_cpu}%{F${cpu_cfore} T1} ${sys_arr[4]}%"
      # mem
      mem="%{F${cpu_cicon}}${sep_l_left} %{T2}${icon_mem}%{F${cpu_cfore} T1} ${sys_arr[5]}"
      # disk /
      diskr="%{F${color_sec_b1}}${sep_left}%{F${color_icon} B${color_sec_b1}} %{T2}${icon_hd}%{F- T1} ${sys_arr[6]}%"
      # disk home
      diskh="%{F${color_icon}}${sep_l_left} %{T2}${icon_home}%{F- T1} ${sys_arr[7]}%"
      ### Net Speed ### {{{
			## made to replace WLAN and Eth sections
			## Will prefer eth0 if up
			if [ "${sys_arr[10]}" == "down" ]; then
				if [ "${sys_arr[8]}" == "down" ];then
					nets_dv="×"; nets_uv="×";
					nets_cback=${color_sec_b1}; nets_cicon=${color_disable}; nets_cfore=${color_disable};
				  else
					nets_dv=${sys_arr[8]}K; nets_uv=${sys_arr[9]}K;
					if [ ${nets_dv:0:-3} -gt ${net_alert} ] || [ ${nets_uv:0:-3} -gt ${net_alert} ]; then
						nets_cback=${color_net}; nets_cicon=${color_back}; nets_cfore=${color_back};
					  else
						nets_cback=${color_sec_b1}; nets_cicon=${color_icon}; nets_cfore=${color_fore};
					fi
				fi
			  else
				nets_dv=${sys_arr[10]}K; nets_uv=${sys_arr[11]}K;
				if [ ${nets_dv:0:-3} -gt ${net_alert} ] || [ ${nets_uv:0:-3} -gt ${net_alert} ]; then
					nets_cback=${color_net}; nets_cicon=${color_back}; nets_cfore=${color_back};
				  else
					nets_cback=${color_sec_b1}; nets_cicon=${color_icon}; nets_cfore=${color_fore};
				fi
			fi
			nets_d="%{F${nets_cback}}${sep_left}%{F${nets_cicon} B${nets_cback}} %{T2}${icon_dl}%{F${nets_cfore} T1} ${nets_dv}"
			nets_u="%{F${nets_cicon}}${sep_l_left} %{T2}${icon_ul}%{F${nets_cfore} T1} ${nets_uv}"
			### End Net Speed ### }}}
			;;
    VOL*)
      # Volume
      vol="%{F${color_sec_b2}}${sep_left}%{F${color_icon} B${color_sec_b2}} %{T2}${icon_vol}%{F- T1} ${line#???}"
      ;;
    GMA*)
      # Gmail
      gmail="${line#???}"
      if [ "${gmail}" != "0" ]; then
        mail_cback=${color_mail}; mail_cicon=${color_back}; mail_cfore=${color_back}
      else
        mail_cback=${color_sec_b1}; mail_cicon=${color_icon}; mail_cfore=${color_fore}
      fi
      gmail="%{F${mail_cback}}${sep_left}%{F${mail_cicon} B${mail_cback}} %{T2}${icon_mail}%{F${mail_cfore} T1} ${gmail}"
      ;;
    IRC*)
      # IRC highlight (script irc_warn)
      if [ "${line#???}" != "0" ]; then
        ((irc_n_high++)); irc_high="${line#???}";
        irc_cback=${color_chat}; irc_cicon=${color_back}; irc_cfore=${color_back}
      else
        irc_n_high=0; [ -z "${irc_high}" ] && irc_high="none";
        irc_cback=${color_sec_b2}; irc_cicon=${color_icon}; irc_cfore=${color_fore}
      fi
      irc="%{F${irc_cback}}${sep_left}%{F${irc_cicon} B${irc_cback}} %{T2}${icon_chat}%{F${irc_cfore} T1} ${irc_n_high} %{F${irc_cicon}}${sep_l_left} %{T2}${icon_contact}%{F${irc_cfore} T1} ${irc_high}"
      ;;
    MPD*)
      # Music
      mpd_arr=(${line#???})
      if [ -z "${line#???}" ]; then
        song="none";
      elif [ "${mpd_arr[0]}" == "error:" ]; then
        song="mpd off";
      else
        song="${line#???}";
      fi
      mpd="%{F${color_sec_b2}}${sep_left}%{B${color_sec_b2}}%{F${color_sec_b1}}${sep_left}%{F${color_icon} B${color_sec_b1}} %{T2}${icon_music}%{F${color_fore} T1}  ${song}"
      ;;
    
    ### Thinkpad Multi Battery ### {{{
		## Icon         0         1         2         3          4
		## Bat >=      NA        11        37        63         90
		## Range     0-10     11-36     37-62     63-89     90-100

		TMB*)
			## Now that I have >12 hours of battery, I don't feel the need for as drastic color thresholds.
			## I will have colors only at much lower percentages.

			tmb_arr_perc=$(echo ${line#???} | cut -f1 -d\ )
			tmb_arr_stat=$(echo ${line#???} | cut -f2 -d\ )
			tmb_arr_time=$(echo ${line#???} | cut -f3 -d\ )

			## This means it will not show up on desktop computers
			if [ "${tmb_arr_perc}" != "none" ]; then
				## Set icon only
				## This is 'hard' coded, instead of in the conf, due to icon font.
				## It will take user intervention if they have a different number of icons
				if [ ${tmb_arr_perc} -ge 90 ]; then
					bat_icon=${icon_bat4};
				elif [ ${tmb_arr_perc} -ge 63 ]; then
					bat_icon=${icon_bat3};
				elif [ ${tmb_arr_perc} -ge 37 ]; then
					bat_icon=${icon_bat2};
				elif [ ${tmb_arr_perc} -ge 11 ]; then
					bat_icon=${icon_bat1};
				else
					bat_icon=${icon_bat0};
				fi

				## Set Colors
				if [ ${tmb_arr_perc} -le ${bat_alert_low} ]; then
					bat_cicon=${color_icon}; bat_cfore=${color_fore}; bat_cback=${color_bat_low};
				elif [ ${tmb_arr_perc} -le ${bat_alert_mid} ]; then
					bat_cicon=${color_icon}; bat_cfore=${color_fore}; bat_cback=${color_bat_mid};
				elif [ ${tmb_arr_perc} -le ${bat_alert_high} ]; then
					bat_cicon=${color_bat_high}; bat_cfore=${color_fore}; bat_cback=${color_sec_b1};
				else
					bat_cicon=${color_icon}; bat_cfore=${color_fore}; bat_cback=${color_sec_b1};
				fi

				## Set charging icon
				if [ "${tmb_arr_stat}" == "C" ]; then
					bat_icon=${icon_bat_plug}; bat_cicon=${color_bat_plug};
				fi
				bat="%{F${bat_cback}}${sep_left}%{F${bat_cicon} B${bat_cback}} %{T2}${bat_icon}%{F- T1} ${tmb_arr_perc}%"

				if [ "${tmb_arr_time}" != "none" ]; then
					bat_time="%{F${color_icon}}${sep_l_left}%{F${color_icon} B${color_sec_b1}} %{T2}${icon_bat_time}%{F- T1} ${tmb_arr_time}"
				  else
					bat_time=""
				fi
			  else
				## If a desktop, show a plug icon. This stops the ugly segment merge that that would happen.
				bat="%{F${color_sec_b1}}${sep_left}%{F${color_icon} B${color_sec_b1}} %{T2}${icon_bat_plug}%{F- T1}"
			fi
			;;
		### End Thinkpad Multi Battery ### }}}

    WSP*)
      # I3 Workspaces
      wsp="%{F${color_back} B${color_head}} %{T2}${icon_wsp}%{T1}"
      set -- ${line#???}
      while [ $# -gt 0 ] ; do
        case $1 in
         FOC*)
           wsp="${wsp}%{F${color_head} B${color_wsp}}${sep_right}%{F${color_back} B${color_wsp} T1} ${1#???} %{F${color_wsp} B${color_head}}${sep_right}"
           ;;
         INA*|URG*|ACT*)
           wsp="${wsp}%{F${color_disable} T1} ${1#???} "
           ;;
        esac
        shift
      done
      ;;
    WIN*)
      # window title
      title=$(xprop -id ${line#???} | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2)
      #title="%{F${color_head} B${color_sec_b2}}${sep_right}%{F${color_head} B${color_sec_b2}%{T2} ${icon_prog} %{F${color_sec_b2} B-}${sep_right}%{F- B- T1} ${title}"
      title="%{F${color_head} B${color_sec_b2}}${sep_right}%{F${color_head} B${color_sec_b2} T2} ${icon_prog} %{F${color_sec_b2} B-}${sep_right}%{F- B- T1} ${title}"
      ;;
  esac

  # And finally, output
  printf "%s\n" "%{l}${wsp}${title} %{r}${mpd}${stab}${cpu}${stab}${mem}${stab}${diskh}${stab}${nets_d}${stab}${nets_u}${stab}${vol}${stab}${bat}${stab}${date}${stab}${time}"
  #printf "%s\n" "%{l}${wsp}${title}"
done
