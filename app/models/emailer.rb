class Emailer < ActionMailer::Base
  def contact(rfile,recipient, subject, message,senderid, sent_at=Time.now)
    @subject=subject
    @recipients=recipient
    @from="anjalicg@gainspan.com"
    @sent_on=sent_at
    @body["title"]='Body title'
    @body["message"]=message
    attachment "application/vnd.ms-excel" do |a|
      a.filename = File.basename(rfile)
      File.open(rfile, 'rb') do |file|
      a.body = file.read
      end
       
      end

    @headers={}
  end
  
end
