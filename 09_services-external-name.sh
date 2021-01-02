#!/bin/bash

kubectl apply -f replicaset-external-name.yml
# replicaset.apps/nginx-testing-external-name created

kubectl apply -f service-external-name.yml 
# service/web created

kubectl get all
# NAME                                    READY   STATUS    RESTARTS   AGE
# pod/nginx-testing-external-name-22gtg   1/1     Running   0          26s
# 
# NAME                 TYPE           CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP      10.96.0.1    <none>        443/TCP   2d1h
# service/web          ExternalName   <none>       myweb.com     <none>    14s
# 
# NAME                                          DESIRED   CURRENT   READY   AGE
# replicaset.apps/nginx-testing-external-name   1         1         1       26s

kubectl exec -it nginx-testing-external-name-22gtg -- bash
curl myweb.com
# <!DOCTYPE html>
# <html lang="en">
#   <head>
#     <meta charset="utf-8">
#     <meta http-equiv="X-UA-Compatible" content="IE=edge">
#     <meta name="viewport" content="width=device-width, initial-scale=1">
#     <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
#     <title>Ree MyWeb</title>
# 
#     <!-- Bootstrap -->
#     <link href="stylesheets/styles.css" rel="stylesheet">
#     <link type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/prism/0.0.1/prism.min.css" media="all" rel="stylesheet" />
#     <link type="text/css" href="stylesheets/styles.min.css" media="all" rel="stylesheet" />
#     
# 
#     <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
#     <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
#     <!--[if lt IE 9]>
#       <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
#       <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
#     <![endif]-->
#   </head>
#   <body>
#     <div class="wrapper">
#       <div class="row">
#         <div class="col-sm-12">
#           <div class="image-small visible-sm visible-xs">
#               <img src="img/mobile-top.jpg" alt="" width="103%">
#           </div>
#         </div>
#         <div class="col-sm-12">
#           <div class="image-small visible-md">
#               <img src="img/mobile-tablet.jpg" alt="" width="103%">
#           </div>
#         </div>
#         <div class="col-lg-6 col-md-6 col-sm-12">
#           <div class="image-large visible-lg">
#             <img src="img/charactersLarge.jpg" alt="" width="103%">
#           </div>
#         </div>
#         <div class="col-lg-6 col-md-12 col-sm-12 right-bottom">
#           <div class="associate-logos visible-lg visible-md">
#             <img src="img/associates.png" alt="">
#           </div>
#           <div class="logo-large visible-lg visible-md">
#             <img src="img/reeLargeLogo.png" alt="">
#           </div>
#           <div class="body-copy">
#             <h1 class="brand">MyWeb <span>GP, LLC</span></h1>
#             <h2>Entertainment Artists Give New Power To University Mascots</h2>
#             <p>
#               When you think of <strong>Marvel, DC Comics, Universal Studios</strong> and <strong>Disney</strong>, also think of <strong>Ree Stickers</strong> from <strong>MyWeb GP, LLC</strong>. Starting in 2016 <strong>MyWeb GP, LLC</strong> began gathering artistic talent that powered the top entertainment brands to give new energy to university mascots.
#             </p>
#             <p>
#               With the new <a href="https://itunes.apple.com/app/id853446994"><strong>Ree Stickers</strong> app</a>, mascots are turned into emoji/stickers that give sport fans and students a way to communicate with their phone like never before. Fans can add their favorite school mascot to texts, messages and other social media venues as they chat about sports, upcoming events and life. That same dynamic mascot artwork is now available for licensing to energize more products for fans.
#             </p>
#             <blockquote>
#               "The extraordinary level of art puts Ree Stickers in a category by itself."<br>
#               <span>Marc Donabella, Trademark &amp; Licensing Director, Syracuse University.</span>
#             </blockquote>
#             
#             <p>The Ree Stickers mascot art from MyWeb GP, LLC can create new opportunities with branding and licensing for your organization. <a href="contact.html">Click here to see their expanding portfolio of mascot art and learn more.</a></p>
#           </div>
#         </div>
#         <div class="mobile-bottom col-sm-12 visible-sm visible-xs">
#             <img src="img/mobile-bottom.jpg" alt="" width="103%">
#         </div>
#       </div>
#     <footer>
#       
#         Copyright 2017. All images are the sole property of MyWeb GP, LLC
#       
#     </footer>
#     <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
#     <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
#     <!-- Include all compiled plugins (below), or include individual files as needed -->
#     <script src="javascripts/bootstrap.min.js"></script>
#     <script src="https://use.fontawesome.com/d44c0b5e1e.js"></script>
# 
#     </script>
#   </body>
# </html>

apt update -y
apt install dnsutils -y

host myweb.com
# myweb.com has address 35.208.103.233
# myweb.com mail is handled by 10 mx10.mailspamprotection.com.
# myweb.com mail is handled by 30 mx30.mailspamprotection.com.
# myweb.com mail is handled by 20 mx20.mailspamprotection.com.

host web      
# web.default.svc.cluster.local is an alias for myweb.com.
# myweb.com has address 35.208.103.233
# myweb.com mail is handled by 10 mx10.mailspamprotection.com.
# myweb.com mail is handled by 20 mx20.mailspamprotection.com.
# myweb.com mail is handled by 30 mx30.mailspamprotection.com.

# If while it pod is running web service is shutdown for any reason, it will timeout,
# but if the service is running again the pod will discover the service again. 
# on other session:  kubectl delete -f service-external-name.yml
host web
Host web not found: 2(SERVFAIL)

# We can appoint services to different sites without modify the DNS 
# on other session:  kubectl apply -f service-external-name.yml
host web
# web.default.svc.cluster.local is an alias for myweb.com.
# myweb.com has address 35.208.103.233
# myweb.com mail is handled by 30 mx30.mailspamprotection.com.
# myweb.com mail is handled by 10 mx10.mailspamprotection.com.
# myweb.com mail is handled by 20 mx20.mailspamprotection.com.

