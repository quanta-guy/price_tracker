import firebase_admin
from firebase_admin import credentials, messaging
from flask import jsonify

# Initialize Firebase with the provided service account key
cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)

# Define a function to send notifications using FCM
def notify(title, msg, reg_token, dataObject=None):
    # Create a multicast message with notification and data
    message = messaging.MulticastMessage(
        notification=messaging.Notification(title=title, body=msg),
        data=dataObject,
        tokens=reg_token,
    )
    
    # Send the multicast message
    response = messaging.send_multicast(message)
    
    # Return a success response
    return jsonify("Success")
