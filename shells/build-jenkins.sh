#!/bin/bash
echo "start build"
pids=()
jobs=()
cmds=()
i=0
ret=1

run (){
  echo "start $1 $(date "+%Y-%m-%d %H:%M:%S")" && npm run  $1  && pids[$i]=$! && echo "end $1 $(date "+%Y-%m-%d %H:%M:%S")" &
  #echo "start $1 $(date "+%Y-%m-%d %H:%M:%S")" && (sleep 4; exit 128;) && pids[$i]=$! && echo "end $1 $(date "+%Y-%m-%d %H:%M:%S")" &
  pids[$i]=$!
  cmds[${pids[$i]}]=$1
  #echo "pid =>$i ${pids[$i]}"
  i=$(($i+1))
}

reap(){
  local status=0
  for pid in ${pids[@]}; do
    #echo "wait pid ${pid}"
    wait ${pid} ; jobs[${pid}]=$?
    if [[ ${jobs[${pid}]} -ne 0 ]]; then
      status=${jobs[${pid}]}
      echo -e "${cmds[${pid}]} exited with status: ${status}\n"
      #unset pids[${pid}]
      #kill -3 ${pids[@]}
      exit ${status}
    fi
  done
  return ${status}
}

#modify open-source code
npm run modifyopensource

#buildlinkidall
run buildcassuccess
run buildlinkid
run buildcaspassword
run buildcasmobile
run buildfacelogin

# buildcasall
run  buildcaslogin
run  buildcasweixin
run  buildcaschangepass
run  buildcasgetwaylogin
run  buildcasgetwayweixin
run  buildcassinglewechat

#buildcasallright
run  buildcasloginright
run  buildcasweixinright
run  buildcasgetwayloginright
run  buildcasgetwayweixinright

#buildcasallbirth
run  buildcasloginbirth
run  buildcasweixinbirth


echo "start wait all pids $i ${pids[@]}"
reap;ret=$?

if [[ ${ret} -ne 0 ]]; then
  (echo "Ooops! Some jobs failed"; exit $ret);
fi

echo "wait finish $ret"
run buildcopy
echo "finished"
exit $ret

