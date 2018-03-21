const functions = require('firebase-functions');
let admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
var badgeCount = 1;
exports.pollAvailable = functions.database
.ref('Polls/{Id}')
.onWrite(event => {
          let poll = event.data.val()
          console.log("Poll",poll)
          sendNotification(poll)
          });

function sendNotification(poll){
    if (poll != null){
    let classId = poll.ClassId;
    let payload = {
    notification: {
    title: "New Poll Available",
    body: "Open aPollo to see the new poll your professor has made available",
    sound: 'default'
        
    }
    };
    if (poll.isAvailable == true){
    return admin.messaging().sendToTopic(classId, payload)
    .then(function(response){
          console.log("Notification sent ", response);
          })
    .catch(function(error){
           console.log("Error sending notification: ", error);
           });
    }
    }
    
}
