---
layout: default
permalink: link-api
description: Développeurs, Datascientists, intégrez l'API décès au sein de vos applications
hero:
  image: /assets/images/persona_7.svg
  image_flip: true
  imageTX: 60px
  background: /assets/images/coding.jpg
title: Intégrer l'API décès
customLayout: true
---

<!-- Prism.js pour le surlignage syntaxique -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/prismjs/themes/prism.css">
<script src="https://cdn.jsdelivr.net/npm/prismjs/prism.js"></script>
<script src="https://cdn.jsdelivr.net/npm/prismjs/components/prism-python.min.js"></script>

<div class="fr-col-xl-6 fr-col-lg-6 fr-col-md-6 fr-col-sm-12 fr-col-12">
    <h3 id="usage">Quelle API pour quel usage</h3>
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

<div class="fr-col-xl-6 fr-col-lg-6 fr-col-md-6 fr-col-sm-12 fr-col-12">
    <a href="https://deces.matchid.io/deces/api/v1/docs" title="documentation OpenApi" target="_self"><img class="fr-responsive-img" src="assets/images/deces-api-swagger.webp" alt="openapi"></a>
</div>

<div class="fr-col-12">
<div class="fr-container-fluid">
<div class="fr-grid-row fr-grid-row--gutters" style="flex-direction: row-reverse;">

<div class="fr-col-xl-6 fr-col-lg-6 fr-col-md-6 fr-col-sm-12 fr-col-12">
    <h3 id="integration-formulaire">Intégration d'un formulaire</h3>
    <p>
        Le cas d'usage basique est l'utilisation, de la recherche simple (<code>q=Pompidou...</code>)
        depuis la valeur d'un formulaire (<code>input</code>).
    </p>
    <img class="fr-responsive-img" src="assets/images/deces-api-search.svg" alt="API search">
    <p>
        Le code <span class="fr-hide--desktop">suivant</span><span class="fr-hide--modbile">ci-contre</span> est l'implémentation de cas en <strong>Svelte.js</strong>. Cliquez sur "output" pour voir le résultat, ou rendez-vous sur ce <a href="https://svelte.dev/repl/442012e7de2d4a4080b1e2c0da359cfe?version=3.31.0" target="_blank" title="REPL">REPL</a>.
    </p>
    <p>
        L'exemple utilise l'API search en mode <code>GET</code>, documentée <a href="https://deces.matchid.io/deces/api/v1/docs/#/Simple/Search" title="API search (GET)" target="_blank">ici</a>.
        Sa transposition en <code>POST</code> est simple et préférable pour la robustesse d'un code de production.
    </p>
</div>
<div class="fr-col-xl-6 fr-col-lg-6 fr-col-md-6 fr-col-sm-12 fr-col-12">
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

<div class="fr-col-xl-6 fr-col-lg-6 fr-col-md-6 fr-col-sm-12 fr-col-12">
    <h3 id="authentification"> Authentification </h3>
    <p>
        L'API est utilisable sans authentification pour un nombre limité d'appels sur l'API de recherche. Pour utiliser l'API au-dela d'une centaine d'appels, ou pour utiliser l'API d'appariement, l'utilisation d'un jeton est nécessaire, tout en restant gratuite.
    </p>
    <p>
        Voici les étapes si vous voulez automatiser l'obtention de la clé d'API pour un an:
    </p>
    <h4 id="creation-jeton"> Étape 1 - Creation manuelle du jeton </h4>
    <p>
        <ul>
            <li>S'enregistrer et confirmer son identité manuellement sur deces.matchid.io</li>
            <li>Récupérer le jeton dans le menu d'utilisateur (en haut à droite) > API Key. La clé devrait commencer par
                <code>eyJhbGc*</code>
            </li>
        </ul>
        Ce jeton est valable 30 jours sans changement et permet de dériver de nouveaux jetons jusqu'à 12 mois.
        L'obtention d'un nouveau jeton (avec confirmation de mail) reste obligatoire tous les 12 mois.
    </p>
</div>

<div class="fr-col-xl-6 fr-col-lg-6 fr-col-md-6 fr-col-sm-12 fr-col-12">
    <h4 id="automatisation"> Étape 2 - Automatisation pour un an </h4>
    <p>
        Vous pouvez rafraîchir votre jeton initial sans limite de la façon suivante:
        <ul>
            <li>
                Pour tout appel à l'API: il suffit d'ajouter le Header: <code>Authorization: "Bearer <i>accessToken</i>"</code>, en remplaçant <code><i>accessToken</i></code> par votre jeton. Des limitations demeurent sur la fréquence d'appel (1/s pour la recherche) mais le nombre d'appels devient illimité.
            </li>
            <li>
                Pour rafraîchir le jeton : avec ce même Header faire un GET sur <code>https://deces.matchid.io/deces/api/v1/auth?refresh=true</code> - ne nouveau jeton récupéré permettra de réitérer les opérations jusqu'à 12 mois.
            </li>
        </ul>
    </p>
    <p>
        Vous pouvez faire une demande de rafraîchissement tous les jours par exemple, il n'y a pas de limite (il est inutile d'en faire une demande a chaque appel, mais ce peut être à chaque session si vous faites des appels consécutifs de 5 minutes ou même moins).
    </p>
</div>

<div class="fr-col-xl-12 fr-col-lg-12 fr-col-md-12 fr-col-sm-12 fr-col-12">
    <h4 id="exemple-code"> Exemple de code Python pour le renouvellement automatique </h4>
    <p>
        Voici un exemple de code Python qui permet de gérer automatiquement le renouvellement du token :
    </p>
    <div style="display: flex; font-family: monospace; border: 1px solid #ddd; border-radius: 6px; background: #fafbfc; box-shadow: 0 1px 2px #0001; margin-bottom: 1em;">
      <div style="background: #f3f4f6; color: #888; padding: 8px 4px; text-align: right; user-select: none;">
        <div style="line-height: 1.5; height: 500px; overflow: hidden;">
          1<br>2<br>3<br>4<br>5<br>6<br>7<br>8<br>9<br>10<br>11<br>12<br>13<br>14<br>15<br>16<br>17<br>18<br>19<br>20<br>21<br>22<br>23<br>24<br>25<br>26<br>27<br>28<br>29<br>30
        </div>
      </div>
      <div style="overflow-y: auto; height: 500px; width: 100%;">
        <pre style="margin: 0; padding: 8px; font-size: 0.9em;"><code class="language-python">import requests
import json
from datetime import datetime, timedelta
import os

MANUAL_TOKEN = os.getenv('MANUAL_TOKEN')

class TokenManager:
    def __init__(self, initial_token):
        self.token = initial_token
        self.last_refresh = datetime.now()
        self.refresh_interval = timedelta(days=1)  # Rafraîchir tous les jours
        
    def get_token(self):
        # Vérifier si le token doit être rafraîchi
        if datetime.now() - self.last_refresh > self.refresh_interval:
            self.refresh_token()
        return self.token
    
    def refresh_token(self):
        headers = {
            "Authorization": f"Bearer {self.token}"
        }
        response = requests.get(
            "https://deces.matchid.io/deces/api/v1/auth",
            params={"refresh": "true"},
            headers=headers
        )
        
        if response.status_code == 200:
            data = response.json()
            self.token = data["access_token"]
            self.last_refresh = datetime.now()
            print(f"Token rafraîchi avec succès. Nouvelle date d'expiration: {data['expiration_date']}")
        else:
            print(f"Erreur lors du rafraîchissement du token: {response.text}")

# Exemple d'utilisation
if __name__ == "__main__":
    # Token initial obtenu manuellement
    initial_token = "eyJhbGc..."  # Votre token initial
    
    # Créer une instance du gestionnaire de token
    token_manager = TokenManager(initial_token)
    
    # Exemple d'utilisation dans une requête API
    def faire_requete_api():
        headers = {
            "Authorization": f"Bearer {token_manager.get_token()}"
        }
        response = requests.get(
            "https://deces.matchid.io/deces/api/v1/search",
            params={"q": "Georges Pompidou"},
            headers=headers
        )
        return response.json()
    
    # La requête utilisera automatiquement un token valide
    resultat = faire_requete_api()
    print(json.dumps(resultat, indent=2))
        </code></pre>
      </div>
    </div>
    <p>
        Ce code implémente une classe <code>TokenManager</code> qui :
        <ul>
            <li>Gère automatiquement le rafraîchissement du token tous les jours</li>
            <li>Vérifie si le token doit être rafraîchi avant chaque utilisation</li>
            <li>Utilise le header d'autorisation approprié pour les requêtes API</li>
        </ul>
    </p>
</div>

<div class="fr-col-xl-6 fr-col-lg-6 fr-col-md-6 fr-col-sm-12 fr-col-12">
    <h3 id="integration-backend">Intégration de l'API d'appariement</h3>
    <p>
        L'API unitaire est limité à une requête par seconde. Pour les appariement en masse,
        une API <code>search/csv</code> permette le traitement de <strong>50 à 100 requêtes par seconde</strong>.
    </p>
    <p>
        Cette API de soumettre un CSV contenant jusqu'à <strong>1 millions d'identité</strong> (100Mo), qui sera complété d'éventuelles détections des données de décès en cas de correspondance celle-ci étant qualifiée par un score de confiance.
    </p>
    <img class="fr-responsive-img" src="assets/images/deces-api-link.svg" alt="API search">
    <p>
        Ces données peuvent être retraitées à l'issue pour être injectées dans votre base de donnée.
    </p>
    <p>
        Voici un exemple minimaliste en Python pour utiliser l'API d'appariement:
    </p>
</div>
<div class="fr-col-xl-6 fr-col-lg-6 fr-col-md-6 fr-col-sm-12 fr-col-12">
    <div style="margin-top:4rem;display: flex; font-family: monospace; border: 1px solid #ddd; border-radius: 6px; background: #fafbfc; box-shadow: 0 1px 2px #0001; margin-bottom: 1em;">
      <div style="background: #f3f4f6; color: #888; padding: 8px 4px; text-align: right; user-select: none;">
        <div style="line-height: 1.5; height: 500px; overflow: hidden;">
          1<br>2<br>3<br>4<br>5<br>6<br>7<br>8<br>9<br>10<br>11<br>12<br>13<br>14<br>15<br>16<br>17<br>18<br>19<br>20<br>21<br>22<br>23<br>24<br>25<br>26<br>27<br>28<br>29<br>30
        </div>
      </div>
      <div style="overflow-y: auto; height: 500px; width: 100%;">
        <pre style="margin: 0; padding: 8px; font-size: 0.9em;"><code class="language-python">import requests
import time
import os
from TokenManager import TokenManager

API_URL = "https://deces.matchid.io/deces/api/v1/search/csv"
token_manager = TokenManager()
API_TOKEN = token_manager.get_token()

# Formulaire multipart avec mapping des colonnes et paramètres CSV
files = {
    'file': ('misc_sources_test.csv',
            open('misc_sources_test.csv', 'rb'),
            'application/csv', {'Expires': '0'}),
    'sep': (None, ','),             # séparateur csv
    'firstName': (None, 'PRENOM'),  # mapping des champs
    'lastName': (None, 'NOM'),
    'birthDate': (None, 'DATE_NAISSANCE'),
    'birthCity': (None, 'COMMUNE_NAISSANCE'),
    'birthDepartment': (None, 'DEP_NAISSANCE'),
    'birthCountry': (None, 'PAYS_NAISSANCE'),
    'sex': (None, 'GENRE'),
    'candidateNumber': (None, '5'),
    'pruneScore': (None, '0.3'),
    'dateFormat': (None, 'DD/MM/YYYY') # format de date
}

headers = {"Authorization": f"Bearer {API_TOKEN}"}
r = requests.post(API_URL, files=files, headers=headers)
print(r.text)
res = r.json()
# Récupération de l'ID pour suivre l'avancement du traitement
print(res['id'])

url_job = API_URL + res['id']
print("url: ", url_job)

r = requests.request("GET", url_job, headers=headers)
print(r.text)
res = r.json()
print(res)

while res['status'] == 'created' or res['status'] == 'waiting' or res['status'] == 'active':
    r = requests.request("GET", url_job, headers=headers)
    try:
        # Vérification de l'état du traitement via JSON
        res = r.json()
    except:
        # Job terminé si réponse non-JSON
        break
    time.sleep(2)
    print(res)

# CSV source complété des données de décès
print(r.text.replace(";","\t"))
        </code></pre>
      </div>
    </div>
</div>

<!-- ──────────────── Paragraphe webhook ──────────────── -->
<!-- Notification des fins de traitement par webhook -->
<div class="fr-col-xl-6 fr-col-lg-6 fr-col-md-6 fr-col-sm-12 fr-col-12">
  <h4 id="webhook-notification">Notification des fins de traitement par webhook (bêta)</h4>

  <!-- 1. Enregistrement du webhook -->
  <h5>1&nbsp;– Enregistrement du webhook</h5>
  <p>
    L'enregistrement préalable du webhook est nécessaire. Il sera authentifié à l'aide d'un challenge. 
    Nous recommendons l'usage de <a href="https://webhook.site" target="_blank">https://webhook.site</a> pour bien comprendre le mécanisme préalablement.
    <br>Notez que nous ne persistons pas ces enrolements, donc il est nécessaire de vérifier le webhook avant chaque appariement, ou tous les mois.
  </p>
  <p> Déclarez d'abord l'URL du webhook : </p>
  <pre><code class="language-bash">curl https://deces.matchid.io/deces/api/v1/webhook \
     -H "Authorization: Bearer &lt;token&gt;" \
     -d '{"url":"https://webhook.site/&lt;uuid&gt;","action":"register"}'</code></pre>

  <p>
    Le service renvoie un <code>challenge</code>. Modifiez votre endpoint pour renvoyer ce challenge texte ou JSON devant contenir le 
    <code>challenge</code>), puis validez le webhook ainsi:
  </p>
  <pre><code class="language-bash">curl https://deces.matchid.io/deces/api/v1/webhook \
     -H "Authorization: Bearer &lt;token&gt;" \
     -d '{"url":"https://webhook.site/&lt;uuid&gt;","action":"challenge"}'</code></pre>
    <p>
        Une fois le challenge détecté, le statut passe à <code>validated</code>. 
        Pour soumettre le job, décommentez dans le code proposé au <a href="#integration-backend">paragraphe précédent</a> le champ <code>webhook</code>
        dans le <code>multipart/form-data</code>. 
    </p>
</div>

<div class="fr-col-xl-6 fr-col-lg-6 fr-col-md-6 fr-col-sm-12 fr-col-12">
  <!-- 4. Implémentation côté webhook (Python minimal) -->
  <h5>2&nbsp;– Implémentation côté webhook (Python minimal)</h5>
    <p> Voici l'implémentation minimale de votre webhook dans une API flask </p>

  <div style="display: flex; font-family: monospace; border: 1px solid #ddd; border-radius: 6px; background: #fafbfc; box-shadow: 0 1px 2px #0001; margin-bottom: 1em;">
    <div style="background: #f3f4f6; color: #888; padding: 8px 4px; text-align: right; user-select: none;">
      <div style="line-height: 1.5; height: 500px; overflow: hidden;">
        1<br>2<br>3<br>4<br>5<br>6<br>7<br>8<br>9<br>10<br>11<br>12<br>13<br>14<br>15<br>16<br>17<br>18<br>19<br>20<br>21<br>22<br>23<br>24<br>25<br>26<br>27<br>28<br>29<br>30<br>31<br>32<br>33<br>34<br>35<br>36
      </div>
    </div>
    <div style="overflow-y: auto; height: 500px; width: 100%;">
      <pre style="margin: 0; padding: 8px; font-size: 0.9em;"><code class="language-python">from flask import Flask, request, Response
import requests
from TokenManager import TokenManager

app = Flask(__name__)
token_manager = TokenManager()  # Différent : utilisation du TokenManager

def download_csv(job_id: str) -> None:
    url = f"{API_URL}/{job_id}"
    headers = {"Authorization": f"Bearer {token_manager.get_token()}"}  # Différent : token dynamique
    r = requests.get(url, headers=headers)
    if r.ok:
        with open(f"results_{job_id}.csv", "wb") as f:
            f.write(r.content)
        app.logger.info("CSV téléchargé : results_%s.csv", job_id)
    else:
        app.logger.error("Erreur téléchargement CSV : %s", r.text)

@app.route("/callback", methods=["POST"])
def callback():
    data = request.get_json(force=True, silent=True) or {}

    if "challenge" in data:
        return data["challenge"], 200

    event  = data.get("event")
    job_id = data.get("jobId")

    if event == "completed" and job_id:
        download_csv(job_id)
    elif event == "failed":
        app.logger.error("Job échoué : %s", job_id)
    elif event == "deleted":  # Nouveau : gestion de la suppression RGPD
        app.logger.info("Fichier supprimé : %s", job_id)

    return Response("OK", status=200)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)</code></pre>
    </div>
  </div>

  <p>
    Notez que notre service ne gère pas de retry en cas d'indisponibilité de votre endpoint. Par ailleurs vous serez également notifié sur le webhook de la suppression du fichier par un <code>"event": "deleted"</code> (par exemple pour traçabilité RGPD).
  </p>
</div>
<!-- ──────────────────────────────────────────────────── -->

{% include algos-link-api.html %}

<div class="fr-col-xl-6 fr-col-lg-6 fr-col-md-6 fr-col-sm-12 fr-col-12">
    <h3 id="integration-ui"> Intégration d'une UI de validation </h3>
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

<div class="fr-col-xl-6 fr-col-lg-6 fr-col-md-6 fr-col-sm-12 fr-col-12">
    <div class="fr-vcenter">
    <img width="100%" src="assets/images/deces-ui-link-validate.webp" alt="valider l'appariement">
    <p>
       Les composants développés implémentent une <strong>mise en exergue des différences champs par champ</strong> (nom, prénom, ...) entre la donnée cherchée et la donnée de référence INSEE. Cette facilitation visuelle est la
       source d'accélération de la validation. Nos implémentations reposent sur la <a href="https://www.npmjs.com/package/diff.js" title="librairie diff.js" target="_blank">librairie diff.js</a>.
    </p>
    </div>
</div>

<div class="fr-col-12 fr-text--center">
    <h3> Pour continuer </h3>
</div>

<div class="fr-col-6 fr-text--center">
    <a href="https://deces.matchid.io/link" class="fr-link fr-link--icon-right" target="_self"> Appariement en ligne</a>
</div>
<div class="fr-col-6 fr-text--center">
    <a href="/algorithms" class="fr-link fr-link--icon-right" target="_self"> Algorithmes</a>
</div>
