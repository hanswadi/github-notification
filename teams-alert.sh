santhosh(){
 WEBHOOK_URL=https://outlook.office.com/webhook/b54bfea2-a3e7-4bc7-97c0-13fabfd5d4b0@6ba04439-8b0e-43ee-ad26-c2ac9ef9e765/IncomingWebhook/2e6a5ad821284ab996250529a4c259a6/208138fc-a8b0-4d9b-934c-a550799ade78
	
 echo ${1}
 TEXT="Hi hello teams"
 MESSAGE=$( echo ${TEXT} | sed 's/"/\"/g' | sed "s/'/\'/g" ) 
 TITLE=$(echo ${1} is not deployed with tag ${2})
 OUTPUT=$(echo ${TITLE} | sed 's/"/\"/g' | sed "s/'/\'/g" )
 NEWTITLE=$(echo ${1} is  deployed with tag ${2})
 NEWOUTPUT=$(echo ${NEWTITLE} | sed 's/"/\"/g' | sed "s/'/\'/g" )
 echo $OUTPUT
 DISCUSSION="{\"title\": \"${OUTPUT}\", \"text\": \"${MESSAGE}\"}"
 DISCUSSION_TITLE="${OUTPUT} is not  deployed"
 JSON="{\"title\": \"${NEWOUTPUT}\", \"text\": \"${MESSAGE}\"}"
 if awk '{for(i=2;i<=3;i++) {print $i}}' santhsosh_output.txt | grep success
 then 
 curl -H "Content-Type: application/json" -d "${JSON}" "${WEBHOOK_URL}"
 elif awk '{for(i=1;i<2;i++) {print $i}}' santhsosh_output.txt | grep Error | sed 's/://g'
 then     
 curl -H "Content-Type: application/json" -d "${DISCUSSION}" "${WEBHOOK_URL}"
 else
 echo "no updates"
 fi
}

discussionservice=dev-1.12.0

sudo fluxctl release --k8s-fwd-ns flux -n qa --workload=qa:deployment/discussion-service-qa-tl-ue1-pod --update-image=760361958090.dkr.ecr.us-east-1.amazonaws.com/discussion-service-tl-ue1-ecr:$discussionservice  

santhosh "sharath-service" $discussionservice

deploymentservice=dev-1.13.0

sudo fluxctl release --k8s-fwd-ns flux -n qa --workload=qa:deployment/discussion-service-qa-tl-ue1-pod --update-image=760361958090.dkr.ecr.us-east-1.amazonaws.com/discussion-service-tl-ue1-ecr:$deploymentservice

santhosh "toorak-service" $deploymentservice


