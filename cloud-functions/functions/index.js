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

exports.attendanceAvailable = functions.database
.ref('Classes/{Id}/AttendanceQuestion/{AId}')
.onWrite(
         event => {
         let q = event.data.val()
         console.log("Att",q)
         sendANotification(q)
         });


function sendNotification(poll){
    if (poll != null){
    let classId = poll.ClassId;
    let payload = {
    notification: {
    title: "New Poll Available",
    body: "Open aPollo to see the new poll your professor has made available",
    badge: badgeCount.toString(),
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
function sendANotification(q){
    if (q != null){
        let classId = q.ClassId;
        let payload = {
        notification: {
        title: "Attendance Open",
        body: "Open aPollo to confirm your attendance to today's class",
        badge: badgeCount.toString(),
        sound: 'default'
            
        }
        };
        if (q.IsAvailable == true){
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
