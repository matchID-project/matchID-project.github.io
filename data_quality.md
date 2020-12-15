---
layout: default
permalink: data_quality
description: Les faux identités peuvent être radiés des bases de données.
image: /assets/images/police-man.svg
image_flip: true
imageTX: 60px
background: /assets/images/database.jpg
title: Fraude à l'identité
customLayout: true
---

<div class="rf-col-12">
<div class="rf-container">
<div class="rf-grid-row rf-grid-row--gutters-h" style="flex-direction: row-reverse;">

<div class="rf-col-xl-6 rf-col-lg-6 rf-col-md-6 rf-col-sm-12 rf-col-xs-12">
    <div class="rf-callout">
    <p>
    Le Système d’Immatriculation des Véhicules (SIV) dispose des informations concernant les titulaires de certificat d'immatriculations. </p>
    <p>
    Il est nécessaire d'enlever les personnes décédées pour améliorer la qualité des données et éviter des cas de fraude liées à l'immatriculation des véhicules. </p> 
    <p>
    [matchID] permet de radier les personnes décédées de forme mensuel au fichier d'immatriculation des véhicules.  </p>
    <div class="rf-text--right"><strong> Agence Nationale des Titres Sécurisés </strong></div>
    </div>
</div>

<div class="rf-col-xl-6 rf-col-lg-6 rf-col-md-6 rf-col-sm-12 rf-col-xs-12">
    <h3> Détection des personnes décédées en masse au sein d'une base de données </h3>
    <p><br></p>
    <p>
        Avez-vous une grande base de données d'identités et vous souhaitez enlever les personnes décédés ?
    </p>
    <p>
    Pour des traitement des données très volumineux vous pouvez installer le produit on-premise sur une infrastructure adapté pour faire le traitement à large échelle.
    Le traitement peut se paralléliser pour réduire notablement les temps de traitement. 
    </p>
    <p>
        Quatre étapes seront nécessaires:
    </p>
</div>

</div>
</div>
</div>

<div class="rf-col-xl-6 rf-col-lg-6 rf-col-md-6 rf-col-sm-12 rf-col-xs-12">
    <h4> Étape 1. Base de données </h4>
    <p>
        Vous pouvez vous lire directement à partir d'une base de données et préparer les requêtes à faire à l'API de traitement.
        Assurez vous d'avoir au minimum le nom, prénom et date de naissance pour faire le rapprochement. Pour garantir plus la fiabilité du rapprochement et éviter les homonymes parfaits (même date de naissance et même prénom), il est recommandé d'utiliser des données sur le lieu de naissance.
    </p>
</div>
<div class="rf-col-xl-6 rf-col-lg-6 rf-col-md-6 rf-col-sm-12 rf-col-xs-12">
    <div class="rf-vcenter">
        <span class="rf-mobile--hide"><br><br><br></span>
        <img class="rf-responsive-img" src="assets/images/deces-backend-test.png" alt="fichier">
        <p>
            Optimiser les paramètres de la requête. Concurrence des taches et taille du chunk à traiter.
        </p>
    </div>
</div>
