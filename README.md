# Een andere manier

De kracht van het internet is dat de technieken relatief eenvoudig te gebruiken zijn. 

Gedreven door het idee dat er binnen enkele seconden iets op het scherm moet staan lijkt het tegenwoordig noodzakelijk om een Single Page App op te tuigen die begint vanuit het neerzetten van placeholders, waarin vervolgens content wordt geladen vanuit GraphQL en REST API’s. En vergelijk dat dan toch eens met de eenvoud van weleer, waarbij je HTML en CSS kon uploaden met een FTP programma… 

Weinig ontwikkelaars weten nog precies wat ze doen, met als prototypische voorbeeld “deze-div-is-een-button” tot gevolg. Of de site werkt zonder javascript is een iets wat naderhand bedacht wordt, misschien omdat iemand zich druk maakt om zoekmachines die geen JavaScript begrijpen?

Het lijkt wel alsof JavaScript noodzakelijk is voor een optimale UX (voor animatie-liefhebbende, goedziende 40-minners dat is).

Maar kan waargenomen snelheid niet ook als “progressive enhancement” aangeboden worden? Als iets zonder JavaScript kan werken, moet het toch ook gewoon zonder kunnen werken. Maar pure HTML en CSS zo snel laten reageren (als het eenmaal geladen is) als een moderne “Single-Page-App” / Webpack-compilatie is niet altijd even gemakkelijk. Je zit dan toch snel van pagina naar pagina te navigeren, die soms sneller, soms minder snel kan reageren. Hoe los je dat dan op? 

De twee technieken die ik in deze blog introduceer komen uit de Ruby on Rails wereld voort, een “backend framework”, maar deze bibliotheken zijn onafhankelijk van dit framework te gebruiken. 

Een belangrijke pijler voor de ontwikkelaars achter Ruby on Rails, en dus ook deze projecten is “convention over configuration”; liever dat iets direct goed werkt, dan dat je dagen aan het sleutelen bent om alleen al de basis goed werkend te krijgen. Het is dan ook sterk geopinieerd. Werk ermee zoals het bedoeld is en je kunt je concenteren op de inhoud in plaats van bijzaken. Omdat het idee van progressive enhancement redelijk centraal in het gedachtengoed zit kan ik er goed mee leven. 

De technieken die ik behandel zijn [Turbolinks](https://github.com/turbolinks/turbolinks) (voor het sneller laten laden van volledige pagina’s), en van meer recentere datum, Stimulus (voor het verrijken van pagina’s). Beiden zijn pragmatische keuzes en relatief kleine verbeteringen, die geen gigantische koerswisseling betekenen ten opzichte van “traditioneel” ontwikkelen op basis van HTML en CSS. 

## Turbolinks

Turbolinks is conceptueel voor een webontwikkelaar wellicht het meest eenvoudige te begrijpen van de twee technieken. Wat als je, wanneer je binnen dezelfde site navigeert, in plaats van de browser te vragen de hele pagina te verversen, je de te presenteren HTML pagina pakt, en slechts de DOM nodes in de body vervangt (+ o.a. de title). Een idee geinspireerd op [pjax](https://github.com/defunkt/jquery-pjax), maar die was afhankelijk van jQuery. De CSS en JavaScript hoeft dan niet meer opnieuw gedownload en geanalyseerd te worden en je kunt bijvoorbeeld JavaScript aan `document` binden die langer leeft dan dat enkele pagina bezoek. Turbolinks vangt wanneer JavaScript aan staat bijna onzichtbaar het openen van links af, en toont wanneer mogelijk direct pagina’s uit de cache waardoor er bijna direct resultaat wordt getoond (welke bij een update wordt ververst). Geen JSON-API’s, geen veranderingen op de server nodig. Een slimmigheid aan de voorkant die ‘traditionele’ websites sneller laat werken.

### Implementatie

Voeg deze regel toe aan de `<head />` van je HTML:

    <script src="https://cdn.jsdelivr.net/npm/turbolinks@5.2.0/dist/turbolinks.js" integrity="sha256-iM4Yzi/zLj/IshPWMC1IluRxTtRjMqjPGd97TZ9yYpU=" crossorigin="anonymous"></script>

De eerste pagina aanroep zal 9.4kB (m.b.v. gzip) meer wegen.

[Turbolinks is ook een package in NPM](https://www.npmjs.com/package/turbolinks), dus je kunt ook je favoriete workflow gebruiken met `yarn` of `npm`.

Het is dan:

    $ npm install --save turbolinks
    
en om het te starten:

    var Turbolinks = require("turbolinks")
    Turbolinks.start()
    
Dat is het. Er zijn vervolgens wat opties om bijvoorbeeld expliciet aan te geven externe bronnen wél opnieuw moeten worden geladen en wanneer een bijzondere pagina niet geladen dient te worden (zoals op [de turbolinks-demo pagina]((https://murb.github.io/turbolinks-stimulus-fronteers/geen_turbolinks.html)))

### En “Native”?

Het leuke aan Turbolinks is dat er ook native implementaties mogelijk zijn, die koppelen events uit de de webpagina’s. Zo kun je relatief eenvoudig web-gestuurde, semi-native, apps bouwen. Maar het gaat te ver om hier diep op in te gaan.

### Demo

Open de ‘[geen turbolinks demo](https://murb.github.io/turbolinks-stimulus-fronteers/geen_turbolinks.html)’ (de menu items gebruiken wel turbolinks na de eerste klik. Wanneer je het netwerkverkeer bekijkt zie je het verschil. Helaas is het verschil met deze zeer compacte statische pagina’s lastig te zien; maar als de CSS, Javascript, en andere zaken complexer worden en een pagina soms iets wordt vertraagd door b.v. een database query, dan is het verschil in snelheid goed te merken.

### Nadelen

De twee belangrijkste nadelen zijn het ontbreken van een document.load en het feit dat de hele DOM wordt vervangen.

Document.load is vooral voor Analytics-systemen en libraries zoals jQuery een aandachtspunt; alle functies die gebonden zijn aan events die standaard aangeroepen worden bij het laden van een pagina moeten mogelijk opnieuw worden gebonden aan events die Turbolinks stuurt bij het navigeren naar een andere pagina.

Een ander punt om in de gaten te houden is dat de volledige DOM relatief ‘dom’ wordt vervangen. Mooie overgangstransities zijn wat lastiger te doen, al zijn er [workarounds](https://github.com/turbolinks/turbolinks/issues/184#issuecomment-451688212) die die eenvoudige werkwijze vervangen door een implementatie die de inhoud van de nieuwe en de huidige pagina-inhoud vergelijkt en netjes bijsnijdt waar nodig.

## Stimulus

Turbolinks brengt op zich al meer een ervaring van een Single Page App zonder gelijk alles wat fijn is aan het maken van ‘traditionele’ pagina’s overboord te gooien. Maar het is niet ideaal voor alles. Soms wil je wat interactiviteit toevoegen. 

Er zijn mensen die niet van frameworks houden. Maar wanneer je vaker van project wisselt, dan is de kracht van een framework wel dat ze enig houvast voor andere ontwikkelaars bieden door dat ze goed gedocumenteerd zijn.

Terzijde: Er zijn ook ontwikkelaars die liever dichter bij webstandaarden blijven en daarom b.v. [WebComponents](https://github.com/w3c/webcomponents/) omarmen. Ik weet het zozeer nog niet, en ben meer gecharmeerd van kleine, comfortabelere, stappen. Stappen die niet direct het vorige volledig breken zonder polyfills.

Stimulus is vooral een handvat om JavaScript code consistent te laten werken. Een logische ordening. Voor dat Stimulus er was, en nadat ik gestopt was met jQuery, schreef ik al voor kleinere projecten veelal JavaScript die reageerde op data-attributen, maar wanneer er het aantal acties groter wordt is het onderhoud van een goede naamgeving toch wel lastig. (en grotere JavaScript projecten waaraan ik werkte bestonden toch veelal uit de bekendere frameworks die zware maar algemeen bekende structuur oplegden, maar met code dat ook ergens weer wrong omdat het eigenlijk niet de manier is waarop ik het liefst frontend-code zou willen schrijven.

Toen ik Stimulus zag was het voor mij dus al snel een aha-moment, al moest ik nog even wachten voordat ik het concreet kon gaan gebruiken op een nieuw project. In plaats van mijn oude manier, waarbij ik acties koppelde aan DOM-nodes middels data-attributen, waarbij al die acties bestonden in dezelfde scope, maar middels een Controller structuur waarin een omsluitend element aangeeft welke Controller binnen dat element het gedrag bepaald. 

### Implementatie

Wil je écht niets te maken hebben met Yarn en/of NPM (en dat is zeker wel zo fijn als je even wilt experimenteren), doe dan:

    <script src="https://cdn.jsdelivr.net/npm/stimulus@1.1.1/dist/stimulus.umd.js" integrity="sha256-mUuPeK7DRsoSOwJJcvbcMgWsqAVPJs7X8K/h7NxXQj4=" crossorigin="anonymous"></script>

Maar [je kunt Stimulus dus ook gewoon op npm vinden](https://www.npmjs.com/package/stimulus).

Stimulus maakt je pagina een kleine 9,81kB zwaarder (met gzip).

HTML en JavaScript zijn traditioneel gescheiden. Je definieert in JavaScript een Controller (ik gebruik hier de wat uitgebreidere syntax die werkt als je de bovenstaande `script`-tag hebt ingevoegd):

    const application = Stimulus.Application.start()

    application.register("validator", class extends Stimulus.Controller {
      static get targets() {
        return [ "name" ]
      }
      method() {
        // doe iets
      }
    }

En de HTML die er bij hoort kan iets zijn als:

    <form data-validator="validator">
        <label>Naam
            <input 
                name="name" 
                data-target="name" 
                data-action="change->method"
            />
        </label>
    </form>

Op ieder ‘change’ event dat het input-veld gegenereerd, wordt `method()` aangeroepen in de Validator-controller.

Zoals [de makers van Stimulus ook al zeggen](https://stimulusjs.org/handbook/building-something-real): “We moeten er rekening mee houden dat mensen problemen hebben met het bekijken van onze applicaties. Bijvoorbeeld door een netwerkstoring, of een uitgevallen CDN die er voor zorgt dat slechts een deel of alle JavaScript niet meer wordt geladen.” Ze noemen het Resilient UI’s. Ik weet niet of ze het boek [Resillient Web Design van Jeremy Keith](https://resilientwebdesign.com/) hebben gelezen, maar het ademt dezelfde geest.

### Demo

[Een Stimulus-demo is hier te vinden](https://murb.github.io/turbolinks-stimulus-fronteers/stimulus.html) en voel vrij om de broncode te bekijken.

### En nu verder?

Ga vooral naar de website om meer te leren over [Stimulusjs.org](https://stimulusjs.org/). Moet je nu alles omgooien om alles met Stimulus te doen? Moet je op zoek naar een stimulus-leaflet npm module? Zeker niet.

## Tot slot

Frameworks bepalen hoe je werkt. Dit kan soms bevrijdend zijn, omdat je er sneller door kunt werken, en gemakkelijker kunt communiceren met je collega’s. Soms kan het ook beperkend zijn omdat je een heel ecosysteem aan plugins en compilers in wordt getrokken waardoor je na ieder update vaak weer in configuratie-bestanden bepaalde details zit te herorganiseren en te configureren omdat weet jij veel. Laat staan dat je tijd hebt om je druk te maken over het werkend houden van de isomorphic rendering-setup en toegankelijkheid.

De frameworks/bibliotheken/libraries, hoe je het wilt noemen, die ik in deze post heb geïntroduceerd zijn mijns-inziens niet van die laatste categorie. Het zijn dusdanig kleine toevoegingen dat het in het framework geweld van vandaag de dag bijna niet meer lijkt op te vallen. Turbolinks is bijna een onzichtbare verbetering wanneer je al gewend was om alle javascript initiaties niet op de `load` en/of `DOMContentLoaded`-events te binden (een gewoonte die er wellicht door jQuery in is geslopen). De bibliotheken bieden structuur, maar zijn ook overzichtelijk.

Besef ook dat veel van de grotere frameworks van grote organisaties komen. Grote organisaties hebben veelal andere problemen dan kleinere. Misschien lossen die frameworks ook wel problemen op die jij nooit zult ervaren. Groter is niet altijd beter.

### Verder experimenteren?

Je kunt de demo pagina’s clonen met git:

    git clone https://github.com/murb/turbolinks-stimulus-fronteers.git
    
Sorry, geen hot reloading, maar met b.v. `python -m SimpleHTTPServer 8000` (of `ruby -rwebrick -e'WEBrick::HTTPServer.new(:Port => 4000, :DocumentRoot => Dir.pwd).start'`) kun je er snel mee experimenteren.