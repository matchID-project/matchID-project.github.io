---
layout: default
permalink: link-api
description: Développeurs, Datascientists, intégrez l'API décès au sein de vos applications
image: /assets/images/persona_7.svg
image_flip: true
imageTX: 60px
background: /assets/images/coding.jpg
title: Intégrer l'API décès
customLayout: true
---

<div class="rf-col-xl-6 rf-col-lg-6 rf-col-md-6 rf-col-sm-12 rf-col-xs-12">
    <h3>Quelle API pour quel usage</h3>
    <p>
        L'API décès possède deux principales fonctions:
        <ul>
            <li>la recherche unitaire</li>
            <li>l'appariement (liste de personnes à rechercher)</li>
        </ul>
    </p>
    <p>
    La première sera utile dans un contexte utilisateur (un <strong>formulaire dte données
    de données d'État civil</strong>, où l'appel API servira à vérifier la vitalité d'une personne).
    </p>
    <p>
    La seconde est utile pour compléter le statut vital d'une <strong>base de donnée clients</strong> au sein d'un système d'information, de plusieurs milliers à environ un million de personnes
    </p>
    <p>
        La <a href="https://deces.matchid.io/deces/api/v1/docs" title="documentation OpenApi" target="_self">documentation de l'API</a> est réalisée au format OpenApi Specification (OAS3, Swagger).
    </p>
    <p>
        Elle décrit de façon détaillée les champs et leur format.
    </p>
</div>

<div class="rf-col-xl-6 rf-col-lg-6 rf-col-md-6 rf-col-sm-12 rf-col-xs-12">
    <a href="https://deces.matchid.io/deces/api/v1/docs" title="documentation OpenApi" target="_self"><img class="rf-responsive-img" src="assets/images/deces-api-swagger.png" alt="openapi"></a>
</div>

<div class="rf-col-12">
<div class="rf-container-fluid">
<div class="rf-grid-row rf-grid-row--gutters-h" style="flex-direction: row-reverse;">

<div class="rf-col-xl-6 rf-col-lg-6 rf-col-md-6 rf-col-sm-12 rf-col-xs-12">
    <h3>Intégration d'un formulaire</h3>
    <p>
        Le cas d'usage basique est l'utilisation, de la recherche simple (<code>q=Pompidou...</code>)
        depuis la valeur d'un formulaire (<code>input</code>).
    </p>
    <img class="rf-responsive-img" src="assets/images/deces-api-search.svg" alt="API search">
    <p>
        Le code <span class="rf-hide--desktop">suivant</span><span class="rf-hide--modbile">ci-contre</span> est l'implémentation de cas en <strong>Svelte.js</strong>. Cliquez sur "output" pour voir le résultat, ou rendez-vous sur ce <a href="https://svelte.dev/repl/442012e7de2d4a4080b1e2c0da359cfe?version=3.31.0" target="_blank" title="REPL">REPL</a>.
    </p>
    <p>
        L'exemple utilise l'API search en mode <code>GET</code>, documentée <a href="https://deces.matchid.io/deces/api/v1/docs/#/Simple/Search" title="API search (GET)" target="_blank">ici</a>.
        Sa transposition en <code>POST</code> est simple et préférable pour la robustesse d'un code de production.
    </p>
</div>
<div class="rf-col-xl-6 rf-col-lg-6 rf-col-md-6 rf-col-sm-12 rf-col-xs-12">
    <div style="overflow:hidden;">
        <iframe frameborder="0" width="100%" height="600px"
            scrolling="no" style="margin-top: -116px;"
            src="https://svelte.dev/repl/442012e7de2d4a4080b1e2c0da359cfe?version=3.31.0"
        ></iframe>
    </div>
</div>

</div>
</div>
</div>

<div class="rf-col-xl-6 rf-col-lg-6 rf-col-md-6 rf-col-sm-12 rf-col-xs-12">
    <h3>Intégration de l'API d'appariement à un backend</h3>
    <p>
        L'API unitaire est limité à une requête par seconde. Pour les appariement en masse,
        une API <code>search/csv</code> permette le traitement de <strong>50 à 100 requêtes par seconde</strong>.
    </p>
    <p>
        Cette API de soumettre un CSV contenant jusqu'à <strong>1 millions d'identité</strong> (100Mo), qui sera complété d'éventuelles détections des données de décès en cas de correspondance celle-ci étant qualifiée par un score de confiance.
    </p>
    <img class="rf-responsive-img" src="assets/images/deces-api-link.svg" alt="API search">
    <p>
        Ces données peuvent être retraitées à l'issue pour être injectées dans votre base de donnée.
    </p>
    <p>
        L'exemple minimaliste suivant est réalisé en Python est dispnible sur ce <a href="https://repl.it/@rhanka/API-deces-linkage#main.py" target="_blank" title="REPL">REPL</a>.
    </p>
</div>
<div class="rf-col-xl-6 rf-col-lg-6 rf-col-md-6 rf-col-sm-12 rf-col-xs-12">
    <div style="overflow:hidden;">
        <iframe frameborder="0" width="100%" height="600px"
            scrolling="no" style="margin-top: 0px;"
            src="https://repl.it/@rhanka/API-deces-linkage?lite=true"
        ></iframe>
    </div>
</div>

{% include algos-link-api.html %}

<div class="rf-col-xl-6 rf-col-lg-6 rf-col-md-6 rf-col-sm-12 rf-col-xs-12">
    <h3> Intégration d'une UI de validation </h3>
    <p>
        Nous vous recommandons dans un premier temps de passer par <a href="https://deces.matchid.io/link" title="appariement sur deces.matchid.io" target="_self">le service en ligne</a> pour tester la validité du fichier et du choix des colonnes à apparier avant d'attaquer le code d'appariement. Vous pourrez, en particulier, vérifier avec l'aide de l'UI de validation.
    </p>
    <p>
        Dans le cas d'un service métier intégré dans un système d'information, pour des appariement réguliers, nous recommandons d'intégrer une UI de validation telle que celle proposée.En effet, l'UI proposée permet de <strong>diviser en moyenne par 10 le temps de validation d'une paire d'identité</strong> par rapport à un affichage en colonnes classiques sous un tableur.
    </p>
    <p>
        Pour traiter un fichie de 100000 lignes, si 10% de personnes sont décédées, environ 9000 seront avec de très bon scores (peu utiles à valider à la main, sauf cas métier nécessitant une assurance complète), et 1000 seront à regarder plus précisément. Ces 1000 cas peuvent prendre moins de 30 minutes avec une UI adaptée, contre une demie jourée sur un tableur.
    </p>
    <p>
        A ce stade, nous n'avons pas mis à disposition de composant réutilisable pour cette fonction.
        Néanmoins <strong>nos deux implémentations d'interface de validation peuvent vous inspirer</strong>: en <a href="https://github.com/matchID-project/deces-ui/blob/dev/src/components/views/LinkCheckTable.svelte" target="_blank" title="composant de validation en Svelte.js">Svelte.js</a> ou en <a href="https://github.com/matchID-project/frontend/blob/dev/src/components/Validation/DataTable.vue" target="_blank" title="composant de validation en Vue.js">Vue.js</a>.
    </p>
</div>

<div class="rf-col-xl-6 rf-col-lg-6 rf-col-md-6 rf-col-sm-12 rf-col-xs-12">
    <div class="rf-vcenter">
    <img width="rf-responsive-img" src="assets/images/deces-ui-link-validate.png" alt="valider l'appariement">
    <p>
       Les composants développés implémentent une <strong>mise en exergue des différences champs par champ</strong> (nom, prénom, ...) entre la donnée cherchée et la donnée de référence INSEE. Cette facilitation visuelle est la
       source d'accélération de la validation. Nos implémentations reposent sur la <a href="https://www.npmjs.com/package/diff.js" title="librairie diff.js" target="_blank">librairie diff.js</a>.
    </p>
    </div>
</div>
<div class="rf-col-12 rf-text--center">
    <h3> Pour continuer </h3>
</div>
<div class="rf-col-6 rf-text--center">
    <a href="https://deces.matchid.io/link" class="rf-link rf-link--icon-right" target="_self"> Appariement en ligne</a>
</div>
<div class="rf-col-6 rf-text--center">
    <a href="/algorithms" class="rf-link rf-link--icon-right" target="_self"> Algorithmes</a>
</div>
