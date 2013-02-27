package org.nchc.crawlzilla.bean;

import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
 
public class sendMailBean {
   public static void main(String[] args)
   {
   try{
   String host = "shunfa@NCHC";
   String from = "shunfa@gmail.com";
   String to = "shunfa@gmail.com";
 
   Properties props = System.getProperties();
   props.put("mail.gmail.com",host);
   Session mailSession = Session.getInstance(props,null);
   Message mailMessage = new MimeMessage(mailSession);
   mailMessage.setFrom(new InternetAddress(from));
   mailMessage.setRecipient(Message.RecipientType.TO,new InternetAddress(to));
   mailMessage.setSubject("Hello JavaMail");
   mailMessage.setText("Wellcome to  JavaMail...!!");
   Transport.send(mailMessage);
   System.out.println("\n Mail was sent successfully.");
   }catch (Exception e){
       System.out.println(e.getMessage());
    }
   }
}