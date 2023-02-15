
# Send an HTML email with an embedded image and a plain text messagel for
# email clients that don't want to display the HTML.
import smtplib, sys, email, os, urllib, ssl
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.image import MIMEImage
from email.utils import formataddr
from email.mime.base import MIMEBase
from email import encoders
#from email.mime.base import MIMEBase

sender_email = "jon.e.clutton@gmail.com"
receiver_email = sys.argv[1]
body = sys.argv[2]
# body2 = open(body, 'r', encoding='utf-8')
# source_code = body2.read() 

attachment = sys.argv[3]

recipients = [receiver_email]

msg2email = MIMEMultipart('related')
msg2email["Subject"] = "Daily Workout"
msg2email["From"] = email.utils.formataddr(('Jonathan Clutton', sender_email))
msg2email["To"] = ", ".join(recipients)
msg2email.preamble = 'This is a multi-part msg2email in MIME format.'


msgAlternative = MIMEMultipart("alternative")
msg2email.attach(msgAlternative)

######### create the plain MIMEText object #############
text = """\
If you see this please contact kuamp@kumc.edu and let the LEAP!Rx know you cannot see
the html version of this email.
"""
msgText = MIMEText(text, 'plain', 'utf-8')
msgAlternative.attach(msgText)


######## Create the html  version of your msg2email ############

html=body
         
msgHTML = MIMEText(html, "html", 'utf-8')
msgAlternative.attach(msgHTML)

#########  Attach html of report #########

filename = "workout.html"
attachment = open(attachment, "rb")
  
part = MIMEBase('application', 'octet-stream')
part.set_payload((attachment).read())
encoders.encode_base64(part)
part.add_header('Content-Disposition', "attachment; filename= %s" % filename)
  #pdf.add_header('content-disposition', 'attachment', filename=basename(attachment_path))
#f=codecs.open(attachment, 'r')

msg2email.attach(part)

####### Create secure connection with server and send email ########

port = 465
context = ssl.create_default_context()

try:
  with smtplib.SMTP_SSL("smtp.gmail.com", port, context = context) as server:
    print( 'waiting to login...')
    server.login('jon.e.clutton@gmail.com', 'pqfecaqfekzbtuzs')
    print( 'waiting to send...')
    server.sendmail(sender_email, recipients, msg2email.as_string())
    print('successfully sent the mail')
except:
        print("failed to send mail")
#if __name__ == '__main__':
#  send_email()














