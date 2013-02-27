package org.nchc.crawlzilla.bean;

import java.security.Security;
import java.util.Date;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
 
public class sendMailBean {
 
   @SuppressWarnings("restriction")
public void sendMail(String mailTitle, String sendTo, String setMsg) throws AddressException, MessagingException, InterruptedException{
	   Security.addProvider(new com.sun.net.ssl.internal.ssl.Provider());
	   final String SSL_FACTORY = "javax.net.ssl.SSLSocketFactory";
	   Properties props = System.getProperties();
	   props.setProperty("mail.smtp.host", "smtp.gmail.com");
	   props.setProperty("mail.smtp.socketFactory.class", SSL_FACTORY);
	   props.setProperty("mail.smtp.socketFactory.fallback", "false");
	   props.setProperty("mail.smtp.port", "465");
	   props.setProperty("mail.smtp.socketFactory.port", "465");
	   props.put("mail.smtp.auth", "true");
	     
	   final String username = "crawlzilla";
	   final String password = "aki1231aki";
	   
	   String signature = "\r\n\r\n" + "--This mail sent by the system automatically, do not reply to this mail.--";
	       
	   Session session = Session.getDefaultInstance(props, new Authenticator(){
	       protected PasswordAuthentication getPasswordAuthentication() {
	           return new PasswordAuthentication(username, password);
	       }});
	   Message msg = new MimeMessage(session);
	   
	   // -- Set the FROM and TO fields --
	   msg.setFrom(new InternetAddress(username + "@gmail.com"));
	   msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(sendTo,false));
	   msg.setSubject(mailTitle + " from Crawlzilla System");
	   msg.setText(setMsg + signature);
	   msg.setSentDate(new Date());
	   Transport.send(msg);
	   Thread.sleep(100);
   }
}