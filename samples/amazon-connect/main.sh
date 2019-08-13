#!/bin/bash

export PATH=$PATH:/opt/awscli

aws --region ${CALL_CENTER_REGION} \
connect start-outbound-voice-contact \
--destination-phone-number ${DEST_PHONE_NUMBER} \
--contact-flow-id ${CONTACT_FLOW_ID} \
--instance-id ${INSTANCE_ID} \
--source-phone-number ${SRC_PHONE_NUMBER}

exit 0