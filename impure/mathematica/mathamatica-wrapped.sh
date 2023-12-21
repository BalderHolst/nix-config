#!/nix/store/rhvbjmcfnkg8i2dxpzr114cp1ws7f667-bash-5.2-p15/bin/sh
#
#  Mathematica 13.1 Front End command file
#  Copyright 1988-2022 Wolfram Research, Inc.

#  Determine the SystemID by examining the output of `uname -s` and 
#  `uname -m`. Failsafe to SystemIDList=Unknown.
if [ -z "${SystemIDList}" ]; then
	case `uname -s` in
		Linux)
			case `uname -m` in
				i?86)
					SystemIDList="Linux";;
				x86_64)
					SystemIDList="Linux-x86-64 Linux";;
				armv?l)
					SystemIDList="Linux-ARM";;
				aarch64)
					SystemIDList="Linux-ARM64 Linux-ARM";;
				*)
					SystemIDList="Unknown";;
			esac;;
		*)
			SystemIDList="Unknown";;
	esac
fi


#  If ${SystemIDList} = Unknown, print an error message and exit
if [ "${SystemIDList}" = "Unknown" ]; then
	ProgramName=`basename "${0}"`
	echo "${ProgramName} cannot determine operating system."
	exit 1
fi

ExecutablesDirectory=$(dirname "`readlink -e "${0}"`")
TopDirectory=$(dirname "${ExecutablesDirectory}")

#  Check SystemID and Mathematica location
for SystemID in $SystemIDList; do
	MathematicaPath="${TopDirectory}/SystemFiles/FrontEnd/Binaries/${SystemID}"
	MathematicaFE="${MathematicaPath}/Mathematica"
	if [ ! -x "${MathematicaFE}" ]; then
		fail=1
		continue
	else
		fail=0
		break
	fi
done
if [ ! "${fail}" = "0" ] ; then
	for SystemID in $SystemIDList; do
		MathematicaPath="${TopDirectory}/SystemFiles/FrontEnd/Binaries/${SystemID}"
		MathematicaFE="${MathematicaPath}/Mathematica"
		echo "Mathematica front end executable"
		echo "${MathematicaFE}"
		echo "not found. Your Mathematica installation may be incomplete"
		echo "or corrupted."
	done
    	exit 1
fi

# Set up library paths
M_LIBRARY_PATH="${TopDirectory}/SystemFiles/Libraries/${SystemID}"
export QT_PLUGIN_PATH="${M_LIBRARY_PATH}/Qt/plugins/"
if [ -n "${USE_WOLFRAM_LD_LIBRARY_PATH}" ]; then
	export LD_LIBRARY_PATH="${M_LIBRARY_PATH}:${M_LIBRARY_PATH}/Qt/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
fi

# Note: this can be removed after migrating to Qt 6.2 (see QTBUG-68619)
if [ -z $QT_QPA_PLATFORM ] ; then
for SystemID in $SystemIDList; do
if [ "${SystemID}" = "Linux-x86-64" ] ; then
	# prefer X11 and use Wayland as a fallback
	if [ "$XDG_SESSION_TYPE" = "wayland" ] ; then
		case "$XDG_CURRENT_DESKTOP" in
			*GNOME*) export QT_QPA_PLATFORM="xcb;wayland" ;;
			*gnome*) export QT_QPA_PLATFORM="xcb;wayland" ;;
		esac
	fi
	break
fi
done
fi

# Ensure matching wolfram, etc., are found
export PATH="${ExecutablesDirectory}:${PATH}"

#set LIBGL flag on Linux-ARM version to prevent crash on startup
if [ "${SystemIDList}" = "Linux-ARM" ] ; then	
	export LIBGL_ALWAYS_INDIRECT=true
	export MESA_FLAG=-mesa
fi

skip_next_arg=false
for arg  do
	case "$arg" in
	-d | --gdb)
		UseGDB=true
		;;
	-e | --env)
		echo "  Started as:             ${0}"
		echo "  Executables Directory:  ${ExecutablesDirectory}"
		echo "  Top Directory:          ${TopDirectory}"
		echo "  VersionID:              $(cat ${TopDirectory}/.VersionID)"
		echo "  CreationID:             $(cat ${TopDirectory}/.CreationID)"
		echo "  Display:                ${DISPLAY}"
		echo "  LD_LIBRARY_PATH:        ${LD_LIBRARY_PATH}"
		echo "  QT_PLUGIN_PATH:         ${QT_PLUGIN_PATH}"
		echo "  QT_IM_MODULE:           ${QT_IM_MODULE}"
		echo "  PATH:                   ${PATH}"
		echo "  ulimit -c:              " `ulimit -c`
		echo "  Layout Hash:            " `cd ${TopDirectory}; find ./ -type f -print | LC_ALL=C sort | md5sum | cut -c 1-32`
		echo "  Libraries:"
		ldd -v "${MathematicaFE}"
		exit
	;;
	-x | --exec)
		if [ -z "$2" ]; then
			echo "  Argument for option '-x' (--exec) missing."
			exit 1
		else
			MathematicaFE=$2
			echo "  Using frontend binary:  ${MathematicaFE}"
			skip_next_arg=true
		fi
		# When using an arbitrary binary, we probably need LD_LIBRARY_PATH.  Set it if we
		# didn't do so above.
		if [ -z "${USE_WOLFRAM_LD_LIBRARY_PATH}" ]; then
			export LD_LIBRARY_PATH="${M_LIBRARY_PATH}:${M_LIBRARY_PATH}/Qt/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
		fi
		;;
	*)
		if [ $skip_next_arg = true ]; then
			skip_next_arg=false
		else
			set -- "$@" "$arg"
		fi
		;;
	esac
	shift
done


#  set espeak data directory
ESPEAK_DATA="${TopDirectory}/SystemFiles/FrontEnd/SystemResources/X/espeak-data"
export ESPEAK_DATA


if [ -z "${UseGDB}" ]; then
	"${MathematicaFE}" ${MESA_FLAG} -topDirectory "${TopDirectory}" "$@"
else
	gdb --args "${MathematicaFE}" ${MESA_FLAG} -topDirectory "${TopDirectory}" "$@"
fi
