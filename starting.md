---
layout: default
permalink: starting
description: installer et lancer l'outil de développement de traitements en 2 minutes
image: /assets/images/persona_5-1.svg
background: /assets/images/matchID-install-bg.gif
imageTX: 40px
imageTY: 105px
title: Débuter avec matchID
customLayout: true
---

<div class="rf-col-xl-6 rf-col-lg-6 rf-col-md-6 rf-col-sm-12 rf-col-xs-12">
    <h3>Prérequis</h3>
    <p>
    matchID nécessite de disposer <code>make</code> et <code>git</code> au préalable. Sur Ubuntu, <code>docker</code> et les outils prérequis sont automatiquement installés.
    </p>
    <p class="rf-text--xs">
    Notes: <br>
    Sous d'autres distributions linux, Mac ou Windows, installez <code>docker</code>, <code>docker-composer</code>, et <code>jq</code>.<br>
    Si vous utilisez un proxy utilisez les variables d'environnement <code>http_proxy</code> et <code>https_proxy</code>. Hors ligne, il suffit de télécharger en plus les <a title="images docker" href="https://hub.docker.com/repository/docker/matchid/">images <code>docker</code></a><br>.
    </p>
</div>

<div class="rf-col-lg-6 rf-col-md-12" style="z-index:-100;">
    <table class="rf-table rf-vcenter">
        <thead>
            <tr>
                <td>Usage</td>
                <td>Configuration</td>
                <td>Capacité</td>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Simple</td>
                <td>2vCPU, 2Go, SSD 10Go</td>
                <td>10k x 1M identés</td>
            </tr>
            <tr>
                <td>Nominal</td>
                <td>8vCPU 16Go, SSD 50Go</td>
                <td>500k x 30M identés</td>
            </tr>
            <tr>
                <td>Complexe</td>
                <td>256Go à 1To, SSD 50Go</td>
                <td>100M x 100M identés</td>
            </tr>
        </tbody>
    </table>
</div>

<div class="rf-col-lg-12 rf-col-md-12">
<div class="rf-container-fluid">
<div class="rf-grid-row rf-grid-row--gutters-h" style="flex-direction: row-reverse;">

<div class="rf-col-lg-6 rf-col-md-6">
    <h3>Démarrer en une minute</h3>
    <p>
        Clônez le code source et rentrez dans le répertoire
        <p class="rf-highlight">
            <code>
            git clone https://github.com/matchID-project/backend<br>
            cd backend
            </code>
        </p>
    </p>
    <p>
        Lancez matchID:
       <p class="rf-highlight">
            <code>
            make up
            </code>
        </p>
    </p>
    <p class="rf-text--xs">
        En cas de problème ou de configuration avancée, reportez vous à la section
        <a title="dépannage" href="/automation#troubleshooting">section dépannage</a>.
    </p>
</div>

<div class="rf-col-xl-6 rf-col-lg-6 rf-col-md-6 rf-col-sm-12 rf-col-xs-12">
    <img class="rf-responsive-img rf-vcenter" alt="installation matchID" width="100%" src="/assets/images/matchID-install.gif">
</div>

</div>
</div>
</div>

<div class="rf-col-lg-12 rf-col-md-12">
    <p>
    Rendez-vous sur votre navigateur sur:
       <p class="rf-highlight">
            <code>
            <a href="http://localhost:8081/matchID/" title="serveur local matchID">http://localhost:8081/matchID/</a>
            </code>
        </p>
        <img class="rf-responsive-img" src="assets/images/frontend-start.png" alt="matchID projects view">
    </p>
</div>


<div class="rf-col-lg-12 rf-col-md-12">
    <h3 class="rf-text--center"> Pour continuer </h3>
</div>
<div class="rf-col-md-6 rf-col-xs-12 rf-text--center">
    <a href="/quick_tutorial" class="rf-link rf-link--icon-right" target="_self" title="tutoriel simple">Tutoriel simple</a>
</div>
<div class="rf-col-md-6 rf-col-xs-12 rf-text--center">
    <a href="/advanced_tutorial" class="rf-link rf-link--icon-right" target="_self" title="tutoriel avancé">Tutoriel avancé</a>
</div>

