# 69 REDIF 11-05-26 Google Gateway

**GMC:** OUI - Demo tracking Google Gateway  
**Duration:** 98 min  
**Language:** fr

---

[00:00] Ok, donc ça filme, ça enregistre.
[00:05] Comme d'habitude, préparez vos questions-réponses.
[00:08] Je ne pense pas que la démo va durer l'heure entière,
[00:12] même si je pense un petit peu moins.
[00:14] Ensuite, on fera une partie questions-réponses.
[00:16] Vous pouvez commencer à mettre les questions dans l'espace conversation.
[00:19] Vous pouvez lever les mains si vous avez des questions.
[00:22] Je récapitule pour ceux qui n'étaient pas encore connectés.
[00:26] Aujourd'hui, l'objectif, c'est vraiment de vous montrer
[00:28] une fonctionnalité bien cachée, pourtant qui est vraiment hyper pratique de Google.
[00:33] C'est le Google Gateway, qui permet de mettre en place
[00:37] un peu l'équivalent d'un tracking server-side.
[00:39] C'est-à-dire que plutôt que de passer par un tiers
[00:43] comme Google Tag Manager pour héberger vos données,
[00:45] vous allez les héberger directement sur votre domaine.
[00:49] Ça permet une remontée beaucoup plus fidèle de la data.
[00:53] Aujourd'hui, c'est vraiment un petit peu le nerf de la guerre
[00:55] avec tout ce qui est cookies,
[00:57] ce qui va être...
[00:58] mise en place notamment au niveau d'Apple et des iPhones.
[01:02] Quand on clique sur une application,
[01:05] l'application, elle...
[01:07] Vous allez avoir un pop-up écrit
[01:09] « Demandez à l'app de ne pas me suivre ».
[01:11] Ça, c'est vraiment un vrai fléau dans l'e-commerce
[01:13] parce qu'on perd énormément de data.
[01:15] Et donc là, ça résout tous ces problèmes-là.
[01:19] Comme je vous le disais en introduction,
[01:21] je pensais me lancer dans des explications un petit peu complexes,
[01:23] mais je suis tombé sur cette vidéo en non répertoriée.
[01:28] Je vais juste partager.
[01:32] Ça partage bien.
[01:37] OK, impeccable.
[01:42] Je me brosse, ça ne le prend pas.
[01:44] Je vais partager une fenêtre, ce sera plus pratique.
[01:48] J'active le lieu.
[01:52] Impeccable.
[01:54] Est-ce que tout le monde voit l'écran ?
[01:58] Oui, c'est bon.
[02:01] Oui, impeccable.
[02:02] C'est parti pour à peu près 4 minutes 32 vidéos.
[02:04] Ensuite, je vous partage l'écran et on met ça en place concrètement.
[02:08] Vous aurez la rediff pour suivre pas à pas ce que je vais faire.
[02:11] J'active la vidéo, je coupe le micro, la caméra.
[02:13] Soyez attentifs.
[02:14] Ces 4 minutes qui résument extrêmement bien
[02:16] ce qui est Google Gateway et le tracking côté third party.
[02:23] Merci.
[02:23] Bienvenue dans 5 minutes.
[02:25] Un produit, une démo, 5 minutes.
[02:27] Aujourd'hui, on va voir comment on peut faire.
[02:28] Et aujourd'hui, zoom sur Google Tag Gateway.
[02:39] Bonjour, je m'appelle Marie.
[02:41] Je suis data et mesures spécialiste.
[02:43] Et je te propose de prendre 5 minutes pour comprendre
[02:45] comment optimiser ta mesure et tes performances
[02:47] grâce à Google Tag Gateway.
[02:50] Dans le monde de la publicité digitale, une chose est claire.
[02:53] La qualité des données est absolument essentielle
[02:55] pour piloter les campagnes et augmenter sa performance.
[02:58] Surtout à l'ère de l'IA.
[03:00] Face à un écosystème technologique et régulatoire en constante évolution,
[03:04] comment s'assurer que chaque euro que tu investis
[03:07] est bien mesuré avec précision
[03:08] tout en protégeant la confidentialité de tes utilisateurs ?
[03:12] Et si la réponse était de transformer cette contrainte en un atout ?
[03:16] Dans cette vidéo, nous allons voir comment tu peux activer
[03:18] Google Tag Gateway, anciennement connu sous le nom de First Party Mode,
[03:22] afin de mieux tirer parti de l'IA de Google
[03:24] grâce à de meilleures données, une vision plus complète
[03:27] et booster la sécurité de l'entreprise.
[03:28] Pour faire simple, Google Tag Gateway est, comme son nom l'indique,
[03:34] une solution de tagging.
[03:35] C'est une méthode optimisée pour configurer tes tags Google,
[03:39] aussi appelée en français « balise ».
[03:41] Cette fonctionnalité te permet de charger tes tags
[03:43] via ton propre domaine, plutôt que depuis les serveurs de Google.
[03:48] Dans un schéma classique de tagging,
[03:55] avec Google Tag Gateway, le script qui charge ton tag
[03:58] est servi depuis ton propre domaine.
[03:59] Il devient donc un script first party.
[04:02] Cela te permet d'obtenir une mesure beaucoup plus robuste,
[04:05] un avantage crucial à l'heure où l'efficacité des scripts tiers
[04:08] est compromise par les navigateurs.
[04:11] Ce changement a des bénéfices très concrets pour toi
[04:13] en matière de mesure des conversions, de performance et de confidentialité.
[04:18] C'est pourquoi il est essentiel d'en faire dès maintenant
[04:21] un élément central de ta stratégie pour te différencier de la concurrence.
[04:25] Alors, quels sont les avantages concrets de la stratégie ?
[04:28] Quels sont les avantages concrets que tu vas pouvoir retirer de cette fonctionnalité ?
[04:30] Tout d'abord, un gain de performance significatif.
[04:34] En activant Google Tag Gateway, tu t'assures du bon chargement de tes tags Google.
[04:38] Cela permet de fiabiliser la remontée de tes signaux
[04:41] et de maximiser ta visibilité sur les conversions.
[04:44] On observe jusqu'à 11% de signaux mesurés en plus.
[04:49] Ces données plus complètes vont permettre d'alimenter plus efficacement
[04:52] nos solutions basées sur l'IA pour optimiser les enchères de tes campagnes
[04:57] et de permettre de faire des changes.
[04:57] Ce qui nous permet d'obtenir un meilleur retour sur investissement.
[05:00] Mais ce n'est pas tout.
[05:01] C'est aussi la garantie d'une confidentialité renforcée par défaut.
[05:05] Avec Google Tag Gateway, tes données sont traitées dans un environnement ultra sécurisé
[05:10] grâce à une technologie appelée Confidential Computing.
[05:13] Imagine un coffre-fort numérique où les données sont chiffrées de bout en bout,
[05:18] de telle sorte que personne, y compris Google, ne peut y accéder pendant leur traitement.
[05:22] Les données non matchées sont ainsi supprimées et ne ressortent à aucun moment
[05:27] sans être sécurisées.
[05:28] Pour activer Google Tag Gateway, il te suffit d'avoir une infrastructure intermédiaire
[05:33] entre ton site et les solutions Google, qui viendra charger ton Google Tag.
[05:38] Il existe deux types d'infrastructures qui permettent de charger ton tag.
[05:41] La première, c'est un réseau de diffusion de contenu,
[05:44] aussi appelé CDN pour Content Delivery Network.
[05:47] La deuxième, c'est un conteneur server-side GTM.
[05:51] Peu importe ta configuration technique, nous avons une solution pour toi.
[05:55] Si l'on zoome sur l'implémentation avec Google Tag Gateway,
[05:57] Si l'on zoome sur l'implémentation avec Google Tag Gateway,
[05:57] si l'on zoome sur l'implémentation avec Google Tag Gateway,
[05:58] sache qu'il est possible d'activer Google Tag Gateway avec n'importe quel CDN
[06:03] via une intégration manuelle facile à mettre en place.
[06:06] Chez Google, nous avons voulu te simplifier encore plus la vie.
[06:09] C'est pourquoi nous développons également des intégrations natives
[06:12] avec les plus grands CDN du marché pour te permettre de bénéficier de Google Tag Gateway
[06:17] en seulement quelques clics, sans aucune difficulté d'implémentation.
[06:21] La première intégration...
[06:26] Allez, hop !
[06:27] Je fais une pause maintenant, puisque après, c'est la partie installation.
[06:32] Et donc, effectivement, ce fameux Gateway...
[06:35] Bienvenue dans 5 minutes.
[06:37] Il aurait pu être un petit peu complexe à mettre en place
[06:40] si on devait le mettre en place avec du code,
[06:43] mais justement, en fait, aujourd'hui, c'est beaucoup plus simple à mettre en place.
[06:50] OK. Est-ce qu'il y a déjà des questions sur la vidéo ?
[06:52] Tout est clair ? Vous êtes prêts à passer à la démonstration ?
[06:57] Donc, justement, on peut voir.
[06:59] Là, sur ce compte, on est typiquement dans ce cas.
[07:03] Si je regarde du 14 avril au 11 mai, on ne fait remonter que 600 balles en achats-ventes,
[07:08] alors qu'en réalité, du 14 au 11, il y a plus de 2000 balles.
[07:16] Donc, je vous laisse imaginer la perte de données.
[07:23] Donc, écoutez, il n'y a pas l'air d'avoir de questions.
[07:25] Vous pouvez me dire que tout est clair dans le chat.
[07:27] C'est plutôt clair.
[07:29] Il a l'air un petit peu boosté, c'est-à-dire dans quel sens ça accède.
[07:33] Et franchement, pour l'avoir, je peux dire, pour l'avoir mis en place,
[07:36] il y a vraiment, c'est vraiment pas mal.
[07:38] En fait, le tracking server site, ça existe depuis un moment,
[07:42] mais ça nécessite soit une installation qui est complexe,
[07:45] soit sinon en passant par des applications comme Stake ou quoi,
[07:50] ça marche, mais ça rajoute un abonnement supplémentaire.
[07:53] Donc, quand il y a un abonnement pour les cookies, pour être CMP,
[07:57] c'est valide avec les cookies, plus un abonnement server site
[08:02] pour pouvoir remonter les données en fonction du nombre de visiteurs
[08:04] que vous avez, ça peut vite chiffrer vite.
[08:07] C'est vrai que, franchement, la solution qu'ils ont mis en place,
[08:11] gratuitement, elle est vraiment pas mal.
[08:14] Exactement, ça évite de payer, mais en plus d'un make-favor,
[08:17] ça évite de multiplier les abonnements.
[08:19] Donc, OK, on se retrouve sur un compte Google Ads
[08:21] et je vais vous montrer concrètement comment est-ce qu'on fait
[08:24] pour mettre tout ça en place.
[08:25] Donc, l'idée, c'est d'aller juste ici,
[08:27] dans la partie outils et dans le gestionnaire de données.
[08:31] Jusque là, de toute façon, vous aurez le replay
[08:33] pour reprendre à votre rythme cette installation.
[08:36] Et donc, dans le gestionnaire de données,
[08:38] ici, vous allez avoir tous les produits associés.
[08:40] Donc, moi, là, je vous recommande vivement de connecter
[08:43] tout ce qui est possible, c'est-à-dire à la fois Google Analytics 4,
[08:47] également Shopify, si vous avez une chaîne YouTube
[08:50] liée à votre marque connectée YouTube,
[08:55] Search Console, d'ailleurs.
[08:57] Vous pourrez l'associer, d'ailleurs.
[08:59] Je ne sais pas pourquoi ce n'était pas associé.
[09:03] Nickel, mais vraiment dans le gestionnaire de données,
[09:04] faites tout remonter, sachant qu'en plus,
[09:06] maintenant, il y a une intégration native avec Shopify.
[09:08] Je l'avais déjà montré dans d'autres lives.
[09:11] Et ici, on peut faire remonter des segments de clients.
[09:14] Donc, ce qui est intéressant, c'est, par exemple,
[09:15] ici, de faire remonter les acheteurs.
[09:17] On peut faire remonter absolument tout ce qu'on veut.
[09:19] Il suffira juste de créer des segments de clients dans Shopify
[09:21] et ensuite de les ajouter à ce niveau-là.
[09:27] Donc, si vous avez tous vos segments Shopify qui remontent,
[09:35] et donc, vous pouvez vraiment créer toutes les listes que vous voulez.
[09:38] Hop.
[09:40] Donc, ce gestionnaire de données, il est assez pratique.
[09:43] Et notamment, c'est ici que vous allez pouvoir gérer la balise Google.
[09:47] Donc, c'est ici que vous allez retrouver votre balise Google.
[09:49] Vous pouvez donc cliquer sur Gérer.
[09:53] Alors ici, plusieurs possibilités.
[09:56] Mais ce qui va être intéressant,
[09:57] ça va être dans un premier temps,
[10:00] eh bien, de bien connecter les différentes destinations.
[10:04] Donc, moi, on voit qu'elle est connectée à la fois à mon compte Google Ads,
[10:08] à GA4 et à mon Channel Manager Google.
[10:11] Donc, tout simplement, instructions d'installation.
[10:13] Après, ça, c'est pour l'intégrer.
[10:16] Mais moi, elle est correctement intégrée.
[10:18] Sinon, vous faites sélectionner votre plateforme.
[10:19] Vous mettez Shopify.
[10:21] Vous aurez l'explication de comment la configurer.
[10:24] Et ensuite, vous pouvez tester votre site web.
[10:27] Donc, l'idée, c'est qu'en fait, quand vous mettez un Tipeee, une cabane, l'URL,
[10:33] vous vérifiez qu'elle est fonctionnelle.
[10:35] Sinon, évidemment, tout ce que je vous montre, ça ne marchera pas.
[10:37] Si vous passez par le Canal Google, normalement, c'est correctement configuré.
[10:42] Donc, comment est-ce qu'on fait pour le retrouver ?
[10:43] Vous faites Boutique en ligne.
[10:47] Et faites pas attention, d'ailleurs, au message en rouge.
[10:49] C'est normal, on est en train de changer le compte de versement.
[10:52] Donc, hop, je fais une bêtise.
[10:55] Canal Google.
[10:57] Et directement ici, vous avez Gérer les paramètres.
[11:02] Et c'est toute la synchronisation des produits.
[11:08] Voilà, ici, mesure des conversions.
[11:12] Balise Google.
[11:13] Et c'est ici, en fait, où ça remonte.
[11:15] Donc, si vous passez par Canal Google, normalement, tout devrait bien être lié.
[11:19] Quand vous mettez votre URL, ça devrait vous mettre le petit panneau vert.
[11:23] Donc, ça veut dire que la balise, elle est correctement installée.
[11:26] En cliquant dessus.
[11:27] Vous pouvez également la renommer.
[11:29] Ça n'a pas vraiment d'importance.
[11:30] Mais par défaut, ça va être un nom un petit peu bizarre.
[11:35] Donc, vous pouvez également la renommer ici.
[11:38] Et pour installer ce fameux Google Gateway,
[11:41] je peux vous dire, franchement, c'était...
[11:43] C'est exclu depuis un moment.
[11:44] Et pourtant, vraiment, il n'y a aucune communication dessus.
[11:46] C'est dans la partie Admin, juste ici.
[11:48] Et vous avez Google Tag Gateway.
[11:50] Améliorer la qualité de vos données en mettant à jour votre balise
[11:53] afin qu'elle fonctionne dans votre contexte first party.
[11:56] Et on voit que c'était incomplet.
[11:58] Donc, moi, je vais cliquer dessus pour pouvoir la mettre en place.
[12:01] Et donc, ici, ça va vous donner des règles d'instruction.
[12:05] Vous allez simplement faire Continuer.
[12:07] Et avec Shopify, ça va se passer avec Cloudflare.
[12:11] Si vous voulez être sûr, vous pouvez copier votre nom de domaine.
[12:13] Vous faites Analyser.
[12:14] Normalement, dans 99 % des cas, ça sera Cloudflare qui sera détecté.
[12:19] Donc, ici, je vais pouvoir continuer.
[12:23] Je vais revoir les instructions.
[12:25] Donc, on va continuer.
[12:31] Parfait.
[12:33] Et donc, ici, il va falloir se connecter à Cloudflare.
[12:40] Alors, vous ne voyez pas la fenêtre qui vient de s'ouvrir,
[12:43] mais simplement, ça vous demande de vous connecter à un compte.
[12:47] En vrai, je pourrais partager tout l'écran puisque je ne vais pas passer.
[12:55] OK.
[13:01] OK.
[13:02] Donc, ici, je vais faire Continuer.
[13:09] Alors, vu que je n'ai pas de compte, je me demande si ça va fonctionner.
[13:16] OK.
[13:17] Et donc, là, après, il va falloir que…
[13:19] Donc, là, il va me dire qu'il n'y a rien qui est détecté.
[13:22] Donc, c'est normal.
[13:23] Donc, je vais mettre à Cloudflare.
[13:28] Hop, connexion.
[13:36] OK.
[13:37] Donc, nickel.
[13:38] Et ici, dans Domaine, je vais devoir ajouter un nom de domaine.
[13:43] Donc, ici, je peux mettre ce que je veux.
[13:47] Je ne sais pas pourquoi il me demande ça, d'ailleurs.
[13:51] Bon.
[13:52] Donc, je vais mettre un nom de domaine.
[13:54] Connecter un domaine.
[13:55] Et ici, je vais mettre Tipee Cabane.
[14:02] OK.
[14:03] Parce que c'est parce que…
[14:14] OK.
[14:15] Donc, pas de HTTPS.
[14:16] Ici, je peux prendre le plan gratuit.
[14:18] Sur le plan gratuit, il y a plus de 100 000 requêtes.
[14:21] Donc, c'est largement suffisant.
[14:23] Et ici, donc, ça va détecter ma zone DNS.
[14:32] Je vais pouvoir continuer l'activation.
[14:34] Et donc, là, c'est là où ça se corse un petit peu.
[14:38] Parce qu'il va falloir changer, donc, les DNS.
[14:43] Hop.
[14:48] Et dans les DNS, paramètres.
[14:55] Alors, je suis en train de me demander parce que vu que je l'héberge sur Shopify, normalement,
[15:01] ça devrait être faisable.
[15:04] Donc, dans la zone DNS, il va falloir que je change les serveurs de nom personnalisés.
[15:16] OK.
[15:17] Donc, parfait.
[15:18] J'avais peur de ne pas pouvoir le faire parce que vu que ce nom de domaine est hébergé
[15:22] sur Shopify, je ne sais pas si on avait la flexibilité de pouvoir changer la zone DNS.
[15:27] Mais donc, je reprends l'activation dans les paramètres dans le domaine.
[15:31] Je vais cliquer donc sur le domaine principal qui est Tipee Cabane.
[15:35] Ici, on va avoir les paramètres de la zone DNS.
[15:38] C'est ici où je vais pouvoir changer les paramètres.
[15:41] Et dans serveur de nom, ici, je vais pouvoir cliquer sur changer.
[15:45] Et je vais utiliser des serveurs de nom personnalisés.
[15:47] Donc, c'est ici où je vais mettre ce que Cloudflare me met.
[15:54] Donc, le premier, c'est celui-ci.
[15:58] Et le deuxième, c'est celui-ci.
[16:03] Là, je vais pouvoir faire enregistrer.
[16:09] Et donc là, c'est bon.
[16:10] Il faudra juste attendre.
[16:15] Je crois que là, ça va mettre un petit peu de temps.
[16:21] On se dit qu'à la fin du live, ça sera updaté.
[16:27] Il faut juste attendre en fait que Cloudflare détecte bien
[16:33] que j'ai changé les paramètres DNS et que je les héberge bien sur Cloudflare.
[16:39] Donc là, à partir de ce moment, on reprendra ensemble la manipulation.
[16:44] Il suffira juste de retourner ici, de refaire la manip.
[16:49] Cloudflare, continuer, se connecter avec Cloudflare.
[16:54] Et donc ici, de l'activer.
[17:03] Mais bon, je pense que là, c'est encore trop tôt.
[17:05] C'est encore trop tôt.
[17:08] Et donc voilà, manipulation quand même pas très compliquée.
[17:12] Ça va juste dépendre si vous l'avez acheté sur OVH ou sur InternetBS
[17:18] ou un autre fournisseur.
[17:19] Ce sera peut-être une manipulation différente au niveau de la zone DNS
[17:22] pour pouvoir changer vers où vous voulez pointer.
[17:26] Et vous pointer vers non pas les DNS d'OVH, les DNS de Shopify ou quoi,
[17:32] mais vraiment de les pointer vers Cloudflare pour activer ce fameux gateway.
[17:38] Donc là, on va attendre tranquillement.
[17:40] D'ici quelques minutes, peut-être pas qu'à la fin de l'heure,
[17:46] ce sera activé.
[17:48] Mais bon, dans tous les cas, après, vous avez la manip.
[17:51] Tristan, vu qu'on touche au DNS, ça ne va pas réveiller le GMC ou je ne sais pas ?
[18:03] Non, parce que là, en fait, c'est vraiment juste,
[18:05] tu le fais pointer vers un serveur différent qui est Cloudflare.
[18:08] OK.
[18:09] Et il n'y a aucun souci.
[18:11] OK.
[18:13] Et j'avais un peu la même crainte que toi,
[18:16] mais ce n'est pas en fait un changement, on va dire, au niveau du CNAME
[18:21] ou de changer le pointage vers Shopify.
[18:23] C'est vraiment juste où est-ce que tu stockes ta donnée.
[18:26] Tu le stockes plus sur les serveurs de Shopify, mais sur Cloudflare,
[18:29] qui est quand même, je pense, l'acteur numéro un du marché actuellement.
[18:36] Et Tristan, je me demandais pour…
[18:38] Là, tu as connecté Google Analytics à ton Google Ads.
[18:41] Est-ce qu'il y avait un live ou un truc où tu avais expliqué comment le setup ou quoi ?
[18:47] Non, mais ce n'est pas très compliqué.
[18:51] Ce n'est pas forcément très compliqué.
[18:54] Tu en parles dans le live Google Ads de janvier.
[18:58] Si tu fouilles un peu dans les redis de live, je crois que tu en parles ici.
[19:01] Je l'active en direct le…
[19:03] Oui, enfin le live d'après ou le live d'avant parce que moi, je l'avais fait et j'avais regardé que ces lives-là.
[19:07] Donc, je pensais sur ces lives-là.
[19:09] Oui, il est activé parce que les lives, j'en avais déjà fait plusieurs fois et ça ne me dit rien.
[19:12] Oui, je ne sais plus alors.
[19:13] Mais oui, il me semble qu'en fouillant, j'avais trouvé.
[19:16] En fait, tu vois, la configuration Google Analytics, si tu passes par Canal Google,
[19:20] elle n'est pas forcément intuitive parce que tu vois, Canal Google,
[19:23] il te permet généralement de créer en un clic.
[19:25] Tu vois, tu peux créer un GMC depuis ou tu peux créer un compte Ads.
[19:30] Tu vois, ça se fait en un clic.
[19:32] Là, en fait, il faut vraiment que tu ailles sur…
[19:34] Attends, je peux le faire…
[19:37] En vrai, je peux créer une propriété pour du beurre.
[19:43] Ce n'est pas très grave.
[19:45] Google Analytics.
[19:50] Toc, toc.
[19:52] Accéder.
[20:03] Est-ce que ça va être ici ? Voilà.
[20:05] Créer.
[20:06] Je vais créer…
[20:08] Attends, on va tout reprendre.
[20:09] Un compte.
[20:10] En gros, ici, le nom du compte, tu peux l'appeler type Yabane.
[20:13] Tu vois.
[20:14] En vrai, ça me fait chier de recréer encore en doublons une propriété.
[20:18] Je ne pense pas.
[20:20] Donc ici, on peut laisser cocher.
[20:22] Nom de la propriété.
[20:24] Je vais mettre type Yabane également.
[20:27] Ici, France.
[20:30] Ça va me le détecter.
[20:32] Juste, il faut que je le mette en euros.
[20:34] Suivant.
[20:35] N'importe, ça n'a pas vraiment d'importance.
[20:42] L'objectif, c'est accroître les ventes, comprendre le trafic web et voir l'engagement et l'attention des utilisateurs.
[20:49] Tu vas pouvoir faire créer.
[20:51] Ici, tu te mets en France.
[20:53] Tu fais j'accepte.
[20:55] Et j'accepte.
[20:57] Nous, le type de plateforme, c'est web.
[20:59] Donc, en fait, c'est ici.
[21:01] Ou…
[21:03] Euh…
[21:05] Yabane.fr.
[21:07] En fait, tu vas mettre l'URL de ton site.
[21:10] Et ici, dans du flux, je peux l'appeler type Yabane aussi.
[21:13] Je vais l'appeler type Yabane 2.
[21:16] Et tu vas pouvoir faire créer et continuer.
[21:19] Et en fait, à partir de ce moment-là, ça va te demander de configurer une balise Google.
[21:25] Donc, moi, là, je ne vais pas aller plus loin parce que du coup, j'ai déjà ma balise Google.
[21:29] Mais si tu as un canal Google, en fait, il va te le proposer.
[21:32] Donc, en fait, tu auras juste ta balise.
[21:34] Et tu fais confirmer.
[21:36] Sinon, s'il ne la détecte pas, c'est qu'il y a un problème dans l'installation.
[21:39] Tu as toujours la possibilité de l'installer manuellement en mettant ce code-là en dessous de ta balise Edge.
[21:44] Mais le mieux, c'est de tout relier à ta balise Google.
[21:46] Parce que tu vois, on l'a vu là, le gateway qu'on vient d'installer, il est…
[21:50] En fait, tu as une espèce de balise Google qui va gérer tout ton raccordement.
[21:54] Et donc, le mieux, c'est de rester là-dessus.
[21:57] Et du coup, je ne vais pas le faire.
[21:59] Primer les modifications.
[22:01] Hop.
[22:04] OK, ça marche.
[22:08] Merci beaucoup, en tout cas.
[22:10] Écoute, pas de souci.
[22:11] Hop.
[22:15] Je ne sais pas si tu peux retourner en arrière.
[22:17] On ne voyait pas, mais je suis en train de…
[22:21] Il faudrait que je vire tes propriétés.
[22:24] Pour éviter de faire des doublons.
[22:27] OK.
[22:28] On peut le faire après.
[22:30] Euh…
[22:32] Pardon.
[22:33] En récupérant un maximum de données grâce à Gateway,
[22:37] donc l'algorithme devient plus performant.
[22:39] Il va pouvoir trouver plus d'acheteurs qui correspondent au profil des acheteurs.
[22:42] En fait, c'est un petit peu ça.
[22:44] Dans le sens où tant que ta campagne, elle est dans une stratégie de maximiser les clics ou en enchères manuelles,
[22:50] en fait, techniquement, ta campagne, elle n'a pas forcément besoin de ta data.
[22:54] En fait, tu vas plus piloter ta campagne.
[22:57] Ah bah tiens, tu as un budget, tu as une limite d'enchères.
[23:00] Je veux que tu me fasses un max de clics avec ça.
[23:02] Par contre, dès que tu vas passer sur du bidding de l'enchère intelligente,
[23:08] en fait, à partir de ce moment-là, tu vas dire à Google,
[23:11] tiens, je te donne tel budget, mais avec la data que tu as,
[23:14] je veux que tu ailles me chercher le plus de performance possible.
[23:16] Donc, en e-commerce, ça va être maximiser la valeur de conversion.
[23:19] Et donc, c'est pour ça qu'à partir de cette étape,
[23:21] l'idée, c'est d'avoir vraiment le tracking le plus performant possible
[23:26] pour vraiment que Google comprenne que tiens, il t'a envoyé ce clic, c'est très bien.
[23:30] Ce clic, il a fait une vente.
[23:31] Donc, il faut que tu trouves des profils similaires.
[23:36] Si tu ne le fais pas, tu vas clairement…
[23:39] Enfin, ta campagne ne pourra jamais s'optimiser.
[23:42] Et s'il n'y a pas ta donnée qui remonte de manière fiable
[23:45] et que tu as une perte de 30, 40, voire même 60%,
[23:48] on peut voir sur Tipeee, Kaven, Stinkata,
[23:52] justement, en fait, tu ne vas jamais réussir à optimiser ton algo
[23:57] ou à basculer ta campagne sur un mode intelligent.
[24:01] Donne-nous ta stratégie pour importer 200, 300 produits
[24:04] en optimisant tout.
[24:05] Images, caractéristiques, produits.
[24:07] Merci.
[24:08] Regarde la vidéo méthode reboot de la formation.
[24:11] Tu l'as déjà vue Adil ou pas, cette vidéo ?
[24:19] Je vais me mettre dans le chat.
[24:22] Et alors, je pense que j'ai loupé une question.
[24:27] Ah oui, j'ai loupé une question.
[24:29] Tu m'as dit, salut Tristan.
[24:30] Ben Samy, on se voit demain d'ailleurs.
[24:32] J'espère que tu vas bien.
[24:33] Je me dis que c'est normal qu'aujourd'hui j'ai lancé la search.
[24:36] La stratégie n'est pas marquée en phase d'apprentissage,
[24:39] mais éligible parce que normalement, dans cet état…
[24:47] Là, il y a deux possibilités.
[24:48] Soit tu as lancé ta search dans une stratégie d'enchaire manuelle
[24:53] ou de maximiser les clics.
[24:54] Et dans ce cas-là, il n'y a pas vraiment besoin de cette phase d'apprentissage
[24:57] puisque, comme je disais,
[24:58] on est vraiment sur un cas où Google ne va pas vraiment apprendre.
[25:01] En fait, il va juste prendre les mots-clés que tu veux viser,
[25:05] va maximiser les clics sur un budget.
[25:09] Donc, ça peut arriver qu'il n'y ait pas forcément de stratégie,
[25:13] d'apprentissage sur des campagnes search
[25:16] en maximisant les clics en enchère CPC manuelle.
[25:19] Deuxième cas de figure, tu as lancé ta campagne.
[25:21] Et je crois que tu me l'as dit, j'ai lancé ma campagne.
[25:25] Est-ce que c'est vrai qu'aujourd'hui j'ai lancé…
[25:27] Donc, la deuxième cas de figure, c'est tout simplement
[25:29] que tu as lancé ta campagne maintenant, qui te marque éligible,
[25:32] mais dès qu'elle va partir, d'ici quelques heures ou demain,
[25:36] elle va passer en apprentissage.
[25:38] Ça dépend.
[25:42] Eh bien, Samuel, je te donne la parole si tu veux poser ta question.
[25:46] Salut Tristan, tu vas bien ? Est-ce que tu m'entends ?
[25:48] Oui, on t'entend très bien.
[25:49] Ok, top.
[25:50] Moi, j'avais une question par rapport à Claude
[25:52] et ça fait un peu écho à la question de Agile.
[25:55] Juste à quel point tu as poussé…
[25:57] Est-ce que tu as poussé comme ça le fait de générer en masse des fiches produits ?
[26:02] Moi, je l'ai fait sur tout ce qui est meta-description et tout ça,
[26:04] URL, ça marchait bien.
[26:05] Est-ce que tu as essayé de le faire sur des fiches d'inscription de produits
[26:09] en te mettant un prompt bien carré, en mettant juste l'URL de ton fournisseur
[26:13] ou AliExpress ou que sais-je, et comme ça générer ?
[26:16] Parce qu'en fait, on peut générer comme ça super vite, à l'infini quoi,
[26:20] juste avec l'URL produit.
[26:21] Je ne sais pas ce que tu veux dire.
[26:23] Tu parles avec l'outil que j'ai développé ?
[26:25] Avec le code.
[26:26] Ok.
[26:27] Enfin, je n'ai pas regardé la méthode de reboot.
[26:29] Enfin, j'ai regardé vite fait comment ça marchait.
[26:31] Mais ça peut se faire aussi avec l'outil que tu as montré dans la méthode reboot.
[26:35] En fait, la limitation d'un cloud code, c'est que…
[26:39] Enfin, en vrai, limitation ou pas, tu pourrais très bien te développer
[26:42] un tool sur mesure qui se connecte en API à ta boutique Shopify
[26:45] et qui fait le rôle d'un make par exemple ou d'un emiten.
[26:49] Oui, c'est ce que j'ai fait.
[26:50] J'ai pris l'API Shopify pour le mettre dans cloud code.
[26:52] Ok.
[26:53] Maintenant, si tu regardes la vidéo sur la méthode reboot,
[26:56] en gros, j'ai injecté…
[26:58] J'ai connecté en API cloud dans un fichier…
[27:02] Attends, je vais te montrer ça.
[27:04] Oui, dans le sheet, je me souviens.
[27:05] Dans le Google Sheet.
[27:07] Donc, en gros, ce qui fait que c'est méga pratique,
[27:10] c'est que tu exportes tes produits et tu vas pouvoir te créer une colonne à droite
[27:14] et tu vas pouvoir réécrire ta colonne par rapport aux différentes informations.
[27:18] Ok.
[27:20] Ah, mais tu fais tout…
[27:21] Enfin, l'API, elle intervient directement sur le sheet.
[27:25] Donc, en soi, tu peux très bien faire un sheet où tu mets tes liens fournisseurs
[27:29] ou tu récupères des informations des liens fournisseurs
[27:32] et tu fais comme ça avec des promptes…
[27:33] Du coup, il faut des promptes par an super carrées quoi parce que…
[27:36] Alors, le plus simple, c'est que tu importes via par exemple un Deezer
[27:39] tes produits sur ta boutique Shopify dans un premier temps.
[27:42] Tu exportes tous tes produits Shopify parce que comme ça,
[27:44] tu vas avoir un fichier qui est formaté pour l'import Shopify
[27:47] et c'est sur ce fichier-là que tu vas venir tout réécrire.
[27:50] Maintenant, pour te donner un ordre d'idée, je ne vais même pas te dire,
[27:54] j'ai généré peut-être en…
[27:56] avec deux liens, je ne sais pas, peut-être 10 000 fiches produits.
[27:59] C'est tout shop confondu.
[28:00] Peut-être même plus.
[28:01] Pas sur un seul shop, mais…
[28:03] Oui, non, sur plusieurs.
[28:05] Moi, je m'en sers énormément.
[28:07] Donc, j'ai une partie de mon activité qui est le fait de créer des faux sites e-commerce
[28:11] et de renvoyer vers des liens d'affiliation.
[28:13] Là, typiquement, on envoie…
[28:16] On a un indien qui fait la liste des 800 produits après à l'import.
[28:21] Ensuite, on le met sur Shopify.
[28:24] Et ensuite, j'ai un scénario make qui vient absolument tout réécrire.
[28:28] Et donc là, les 800 fiches produits, elles sont faites en quelques heures
[28:32] avec le lien tout automatisé.
[28:34] Donc là, il n'y a vraiment aucune limite.
[28:36] Après, ce que je parle, c'est des notions qui sont un petit peu avancées.
[28:38] Pour certains d'entre vous, je ne sais pas si tout le monde…
[28:41] En tout cas, pour les rendez-vous que j'ai pu avoir sur des personnes
[28:44] qui sont à une phase de création de boutique,
[28:46] ce sont des méthodes que je ne recommande absolument pas.
[28:48] Dans un premier temps, pour vos premiers shops, faites-le à la main.
[28:51] Être bon en automatisation.
[28:54] Il faut avoir fait le processus des dizaines de fois à la main
[28:58] pour savoir comment l'automatiser.
[29:00] Non, mais c'est pour ça que je t'ai demandé.
[29:01] Je te l'ai dit, je n'ai fait qu'avec les URL et les métadescriptions.
[29:03] Parce qu'il n'y a pas besoin pour même 40, 50 produits, ça ne sert à rien.
[29:06] Mais juste pour savoir comment ça marche.
[29:08] Mais OK, c'est pour savoir.
[29:10] Et après, c'est ça.
[29:11] Tu vois, moi, des fois, on lance des shops avec 50 produits.
[29:14] Et je me dis, quid de ça va me prendre 5 heures
[29:18] de pousser la connexion entre make et le Shopify,
[29:21] de refaire tous les scénarios, de refaire tous les prompts,
[29:23] pour voir si ça ne va pas plus vite.
[29:25] Alors qu'en vrai, tu le fais à la main.
[29:27] Oui, c'est ça.
[29:28] Tu fais tous tes prompts et tout, tout ton process.
[29:30] Et ça prend 6 heures, mais tu n'as pas de galère.
[29:32] Alors qu'en vrai, avec l'IA, tu peux avoir quand même des soucis.
[29:35] Après, si ton shop est voué à évoluer
[29:40] et que tu as, dans un premier temps, 20 produits à faire,
[29:43] mais que tu as un objectif de 200, 300 produits,
[29:46] ça vaut peut-être le coup de le mettre en place maintenant.
[29:48] Et plus tard, comme ça, tu as directement une automatisation de prêt.
[29:50] Moi, tu vois, les boutiques,
[29:52] tous les mecs sont branchés et tout.
[29:54] Dès qu'on rajoute des produits,
[29:56] j'ai juste à appuyer sur un bouton et il fait les nouvelles fiches produits.
[29:59] Ah, quand ton concurrent ajoute un produit ?
[30:02] Non, je ne sais pas non plus.
[30:03] Non, en gros, si tu veux, moi, j'ai fait le travail.
[30:06] En fait, ça, ça prend du temps de l'intégrer.
[30:08] Et une fois que tu l'as intégré, tu vois, demain,
[30:11] nous, pour de l'affiliation, tu vois, je ne sais pas,
[30:14] Maison du Monde, ils ont sorti 60 nouveaux canapés.
[30:17] En fait, notre intégrateur, il va mettre les 60 produits dans Shopify.
[30:21] Oui.
[30:22] Il va mettre en brouillon.
[30:23] Mon scénario mec, en fait, il récupère tous les produits en brouillon.
[30:26] Il rédige le titre, il rédige la description,
[30:29] il refait les images, il fait ci, il fait ça, etc.
[30:32] Et ensuite, une fois qu'il a fini, il passe le produit en actif.
[30:34] Ok, ok.
[30:35] Ce qui fait qu'il ne repasse pas, il ne boucle pas sur les produits.
[30:38] Puisqu'en gros, il détecte uniquement les brouillons.
[30:40] Mais une fois que c'est mis en place, tu vois,
[30:42] demain, tu dois rajouter 60 nouveaux produits.
[30:44] Tu as juste à appuyer sur un bouton et c'est clair.
[30:46] Mais je le redis.
[30:47] Ça, c'est l'étape avancée.
[30:49] C'est pour ça que je t'ai demandé plutôt que de passer 6 heures à le faire.
[30:52] Oui, j'ai d'autres questions, si ça ne te dérange pas.
[30:54] C'est le but, vas-y.
[30:56] En gros, là, je n'ai pas sur un de mes shops, j'ai passé le GMC et tout.
[30:59] J'ai fait une petite campagne.
[31:00] J'ai mis 150 euros d'ad juste pour chauffer le compte.
[31:03] J'ai remis 1 euro pour faire le branding.
[31:06] Et en fait, c'était mon premier shop.
[31:08] Donc, il n'est pas fou, quoi.
[31:10] Et la description, elle est immense.
[31:12] Mais vraiment, elle est immense.
[31:13] Elle prend la moitié de la page.
[31:14] Donc, est-ce que je peux la mettre en boulette sans recompiler le GMC ?
[31:18] Sans que le GMC repasse un coup sur ma fiche produit ?
[31:21] Ou ça, ça va redéclencher une vérification ?
[31:23] Ça ne va pas redéclencher une vérification.
[31:25] Si ton GMC est déjà passé, ça va simplement mettre à jour ta fiche produit
[31:28] avec les nouvelles informations.
[31:30] OK. Donc, modifier les fiches produits, ça ne pose pas de problème.
[31:33] Le seul truc qui pose problème, c'est la première image et le titre.
[31:36] Au début.
[31:38] Mais disons qu'une fois que ton GMC est en place, petit à petit, tu fais des modifications.
[31:43] Mais même en vrai, moi, j'ai déjà modifié tout d'un coup.
[31:45] Ah, mais toi, tu as passé toutes les GMC.
[31:47] Donc, bon.
[31:48] Non, mais tu vois, par exemple, sur une boutique avec Symprozy,
[31:52] je suis passé de...
[31:54] Tu sais, tu as deux possibilités.
[31:55] Soit tu mets le nom SEO, soit tu mets le nom du produit.
[31:57] Je suis passé de nom de produit à nom SEO.
[31:59] Donc, ça va modifier tous mes noms.
[32:01] Je vais synchroniser le catalogue.
[32:02] D'un coup, ça fait tout le catalogue.
[32:04] Il n'y a eu aucun problème.
[32:05] OK, top.
[32:06] Bon, je vais faire ça.
[32:07] En tout cas.
[32:10] Et ouais, j'ai dit que...
[32:11] Ouais.
[32:12] Enfin, je vais te dire, pour ce genre de modification,
[32:14] en fait, il ne faut pas être trop frileux, on va dire.
[32:17] C'est pas...
[32:19] Ça dépend, en fait, à quelle étape tu en es.
[32:21] Mais une fois que ton shop, il a dépensé...
[32:23] Oh non, mais j'ai vendu plusieurs mois.
[32:25] Et il y a un mois et demi, celui-là,
[32:27] où j'ai changé les sections.
[32:29] Et je n'ai jamais pris de bannes encore.
[32:31] Enfin, j'ai pris des piliers de risque, mais je n'ai pas pris de bannes.
[32:33] Donc, c'est pour ça que je...
[32:35] Et après, j'ai une question aussi.
[32:37] Je pense que ça lui arrive à d'autres gens.
[32:39] C'est pour ça que je la pose ici.
[32:41] Sur le téléphone, là, mes trois shops,
[32:43] ils s'affichent correctement et tout.
[32:45] Mais ce n'est pas la première fiche.
[32:46] C'est-à-dire que ce n'est pas l'image fond blanc.
[32:48] C'est une image, genre la deuxième ou la troisième.
[32:50] Et ça ne se passe que sur le téléphone.
[32:52] Et je ne sais pas si ça arrive à d'autres gens,
[32:54] ou c'est que mes shops, je ne sais pas ce qu'il y a.
[32:56] En shopping, tu parles ?
[32:58] Non, non.
[33:00] Quand j'affiche le site,
[33:02] genre sur Google, je tape mon site.fr sur Google.
[33:04] Et quand je scrolle et tout,
[33:06] ça ne met pas la première image produite.
[33:08] Alors, attends.
[33:10] Mais c'est que sur le téléphone.
[33:12] C'est pour ça que c'est bizarre.
[33:14] C'est sur le résultat SEO que tu parles.
[33:16] Euh...
[33:20] Ben non, là, je tape juste mon site.
[33:22] Genre mon URL dans Google, directement.
[33:26] Attends, je vais partager l'écran.
[33:30] Est-ce que tu me parles que là, à côté de ton résultat,
[33:32] tu as une petite image,
[33:34] tu as un petit carré ici ?
[33:36] Non, non, non.
[33:38] Vraiment, là, tu fais un clic sur ton site.
[33:40] Oui.
[33:42] Moi, j'aimerais bien que les images,
[33:44] enfin les images produits, pour chaque produit, ce soit la première.
[33:46] Donc l'image fond blanc, pour que ce soit cohérent.
[33:48] Et moi, c'est la deuxième ou la troisième, tu vois.
[33:50] Enfin, ça dépend. En fait, c'est super random.
[33:52] En fait, toi, c'est pareil, en soi.
[33:54] Oui, mais ça, c'est parce que je les ai mal fait.
[33:56] Donc là, en fait, ce que tu dis, ce n'est pas un problème.
[33:58] En fait, c'est
[34:00] tout simplement,
[34:02] dans la partie
[34:04] produits,
[34:06] quand tu vas sur un produit,
[34:08] en fait, il faut que tu chopes ton image
[34:10] et que tu la bases en première.
[34:12] Oui, ça, je l'ai fait, bien sûr.
[34:14] Et...
[34:16] Alors, ce qui est possible,
[34:18] c'est que tu aies des variantes.
[34:20] Tu utilises quoi
[34:22] comme thème ?
[34:24] Horizon.
[34:26] OK. Donc, ce qui est possible...
[34:28] Donc, ça serait à vérifier. Mais c'est, imaginons
[34:30] que tu aies des variantes. En fait, si, ici,
[34:32] je mets une image différente,
[34:34] en fait, tu auras beau avoir cette image-là
[34:36] en principale, ça peut être l'image de variante
[34:38] qui affiche.
[34:40] Je pense que c'est ça, parce que c'est que sur mes produits qu'ont des variantes.
[34:42] Ah, et bien, c'est ça, le problème.
[34:44] Donc, là, c'est juste ton code, en fait.
[34:46] Il faut que tu changes de thème parce que ton code...
[34:48] Ou que tu fasses une modif dans le code
[34:50] pour forcer, en fait, l'affichage, même si c'est une variante.
[34:52] Forcer l'affichage du...
[34:54] Mais c'est que sur le téléphone, donc c'est un peu bizarre.
[34:56] Bon, c'est pas bien grave,
[34:58] c'est pas non plus...
[35:00] Mais là, je peux déjà te donner des pistes.
[35:02] Ton problème est clairement
[35:04] d'un problème de ton thème sur Shopify.
[35:06] Mais c'est bizarre, j'ai sur deux thèmes différents,
[35:08] j'ai deux fois le même problème.
[35:10] Ouais, je sais pas. Je vais fouiller, quoi. Merci.
[35:12] Pas de soucis. Merci, merci.
[35:14] T'inquiète. Alors, je prends quelques questions
[35:16] écrites.
[35:18] Ah, Manon qui dit, moi, je suis avec Simprozis.
[35:20] Est-ce que tu me conseilles
[35:22] de quand même télécharger Canal Google
[35:24] où ça va faire des doublons ?
[35:26] Hum...
[35:28] N'installe surtout pas Canal Google
[35:30] parce que sinon, tu vas avoir deux flux.
[35:32] Et effectivement, ça va te créer un doublon.
[35:34] Par contre, sur Simprozis...
[35:40] Ouais, je peux montrer ça.
[35:44] Mais en vrai, Manon,
[35:46] je préfère te le dire parce que
[35:48] c'est un peu compliqué.
[35:50] Tu sais quoi ? Écris-moi sur WhatsApp et on verra
[35:52] pour un rendez-vous.
[35:54] Je pense que dans le nouveau module de la formation,
[35:56] je vais me trouver. En fait, sur Simprozis,
[35:58] dans Tracking Tag, t'as
[36:00] un endroit où il y a marqué
[36:02] Tracking Server Size. Et effectivement,
[36:04] Simprozis, ils vont assez loin dans le
[36:06] dans le tagging.
[36:08] Et dans tous les cas, même avec Simprozis,
[36:10] t'as une balise Google qui est connectée.
[36:12] Donc, tu peux faire ce que j'ai montré.
[36:14] Mais à savoir que si t'as Simprozis,
[36:16] ils ont mis pas mal de choses en place.
[36:18] Regarde, va dans Simprozis, tu vas dans Tracking Tag
[36:20] et t'as notamment le conseil de mode que tu peux
[36:22] activer et t'as aussi le Tracking Server Size
[36:24] sur GA4 qui marche plutôt bien.
[36:26] Je commence à être calé sur le sujet
[36:28] parce que ça fait deux semaines que je pense
[36:30] le truc pour vous trouver la meilleure
[36:32] méthode de faire.
[36:34] Et vu que je sais que le tracking, c'est quand même
[36:36] très technique,
[36:38] j'ai pas envie de vous embarquer dans les trucs de code,
[36:40] de GTM, de choses comme ça.
[36:42] Donc, j'essaie de vraiment trouver des solutions assez simples.
[36:44] Bonjour Tristan,
[36:46] j'avais une question.
[36:48] Pour les images prod,
[36:50] tu les recrées après ou tu gardes
[36:52] celles que tu as importées ?
[36:54] Ça dépend à dire si celles que j'ai importées sont de bonne qualité.
[36:56] Notamment, je pense à tout ce qui va être décoration
[36:58] type horloge murale.
[37:00] Clairement, je me prends pas forcément à tête de les refaire
[37:02] même si en soit, il y a une plus-value
[37:04] énorme aujourd'hui avec IA.
[37:06] Il y a vraiment moyen de faire des belles choses,
[37:08] mais je sais que c'est chronophage.
[37:10] Donc là, ça va vraiment dépendre.
[37:12] Mais sinon, après oui, je prends aussi un peu de temps sur Photoshop
[37:14] à faire des visuels,
[37:16] à rajouter des dimensions, des choses comme ça.
[37:18] J'ai une autre question
[37:20] pour un autre shop où j'ai eu plus de vente.
[37:22] Je n'ai pas réussi d'avoir d'autres ventes.
[37:24] Ça ne me dérange pas de donner la niche.
[37:26] C'est l'utile automatique et arbre achat.
[37:28] Mais ces niches-là, elles sont
[37:30] trop de monde dessus.
[37:32] Il faut vraiment partir sur des
[37:34] choses...
[37:36] C'est à cause de l'espoir.
[37:38] Il y a aussi cette niche.
[37:40] C'est pas ça.
[37:42] Il faut essayer de...
[37:44] C'est vraiment tout ce qu'on vend dans la formation.
[37:46] Il y a 20 boutiques de...
[37:48] Il y a 3-4 boutiques qui marchent
[37:50] et je pense 20 boutiques qui vont sortir
[37:52] dans les semaines, tu vois.
[37:54] Donc...
[37:56] C'est la marge des bons fournisseurs.
[37:58] Moi, ce que je te recommande, effectivement,
[38:00] beaucoup de concurrence, soit ça va être de
[38:02] vraiment faire un super copywriting,
[38:04] soit ça va être de trouver dans la niche des chats
[38:06] d'autres produits qui se vendent également très bien.
[38:08] Et Tristan ?
[38:10] Oui ?
[38:12] Dis-moi, au niveau de la formation,
[38:14] pour la recherche produit,
[38:16] la méthode, elle va changer ou...
[38:18] Ou pour l'instant, on garde la même méthode ?
[38:22] C'est-à-dire ?
[38:24] Tu sais, dans la formation et tout,
[38:26] les coachs, ils me disent
[38:28] il faut que tu aies minimum 3
[38:30] concurrents en Europe, en France.
[38:32] Il faut que tu aies tant
[38:34] de recherches mensuelles, ainsi de suite.
[38:36] Et des fois, on avait une problématique
[38:38] où on se retrouvait sur des niches où il y avait
[38:40] peut-être un concurrent ou même peut-être personne.
[38:42] Pourtant, il y a beaucoup de recherches mensuelles.
[38:44] Et pourtant, tu vois...
[38:46] Mais ça, je te l'avais déjà dit.
[38:48] Le rôle des coachs, c'est
[38:50] de prendre le moins de risques possible.
[38:52] Surtout, t'imagines, pour des débutants qui se lancent sur le premier truc.
[38:54] Tu peux tomber sur une niche...
[38:56] En fait, disons qu'il y a quand même des voyants.
[38:58] C'est-à-dire que si t'as une niche
[39:00] avec déjà des concurrents, pas trop,
[39:02] qui sont déjà établis en dropshipping,
[39:04] qui font de la pub depuis un moment,
[39:06] c'est un bon facteur pour dire qu'il y a quand même peu de risques.
[39:08] Maintenant, si tu veux vraiment trouver
[39:10] des pépites,
[39:12] très bien, allez.
[39:14] Mais vraiment, je pense à des niches B2B,
[39:16] des clics pour trouver des voitures,
[39:18] des choses comme ça. Mais vraiment,
[39:20] des caméras pour inspecter des tuyaux,
[39:22] il y a des niches de dingue,
[39:24] avec des marges de dingue,
[39:26] et il n'y a personne dessus. Vraiment.
[39:28] Je pense que là, c'est dur de deviner l'avatar client
[39:30] quand il n'y a personne dessus sur des produits genre
[39:32] les caméras de tuyaux.
[39:34] Tu ne sais pas comment le vendre, le truc.
[39:36] Tu ne sais même pas qui c'est qui va vraiment l'acheter.
[39:38] C'est là où c'est un peu compliqué, je trouve.
[39:40] Typiquement, ça, aux US,
[39:42] tu as plein de gens qui font un peu des
[39:44] grosses cultures.
[39:46] Bref, un truc, je vous donne des idées comme ça,
[39:48] mais il y a vraiment un milliard. J'essaie de trouver des trucs
[39:50] vraiment WTF pour...
[39:52] Il a un shop,
[39:54] il ne vend que des pompes. Des pompes
[39:56] à eau, à huile, à tout. Pas des pompes
[39:58] industrielles, des pompes domestiques,
[40:00] ils ne vendent que des pompes.
[40:02] Et genre, ça marche pour lui, tu vois,
[40:04] aux US, pour te donner une idée.
[40:08] D'ailleurs, par rapport aux pompes,
[40:10] j'accompagne un client
[40:12] que j'ai plutôt sur ma casquette
[40:14] agence qui, effectivement, vend des pompes
[40:16] industrielles. Alors là, évidemment, vous ne vous lancez pas
[40:18] dessus. Il travaille avec les plus
[40:20] grands groupes mondiaux.
[40:22] Il vend des pompes
[40:24] à 100 000 balles. Mais
[40:26] c'est plusieurs millions, deux millions,
[40:28] deux dizaines de millions par an qu'il fait sur...
[40:30] Mais c'est pour vous dire, il y a vraiment des niches.
[40:32] Il faut aussi un petit peu élargir son
[40:34] spectre. Par rapport à ça, quand on dirait que
[40:36] tu commences à devenir
[40:38] le boss, quoi.
[40:40] Il dit comme boss, ça. Est-ce que vous allez
[40:42] peut-être avoir un pourparler avec les coachs
[40:44] et tout, pour essayer de voir un peu au niveau
[40:46] de la recherche produit ? Parce que du coup, en fait,
[40:48] j'ai remarqué que du coup, tous les élèves,
[40:50] ils se retrouvent sur les mêmes produits. Parce que
[40:52] quand tu regardes bien avec tous les critères,
[40:54] tu n'as pas beaucoup de choix de produits, en fait.
[40:56] Moi, je trouve
[40:58] que ça, c'est un problème par lequel on est
[41:00] tous passés. Et je pense que
[41:02] au bout de, je pense, un mois et demi,
[41:04] deux mois, tu commences
[41:06] à comprendre le truc.
[41:08] Parce qu'on est tous
[41:10] passés par la phase où on commence
[41:12] à s'ennuyer dans la recherche produit, on tourne en
[41:14] rond, etc. Mais en vrai, c'est juste
[41:16] que petit à petit,
[41:18] enfin, petit à petit, tu auras des idées,
[41:20] je pense. Tout ouvre tes
[41:22] chakras. Parce que c'est ça.
[41:24] Les modules sont très complets.
[41:26] Je pense qu'il n'y a pas... En vrai, je trouve qu'au début,
[41:28] on commence en recherche
[41:30] des produits de fou, et après, on se rend compte
[41:32] que tout se vend. Donc,
[41:34] en vrai, il n'y a pas besoin de faire une recherche de fou.
[41:36] La sortie Ikea et le Roi Merlin, en vrai,
[41:38] ça peut donner grave des idées.
[41:40] Mais je vais
[41:42] quand même, effectivement,
[41:44] faire un rapport.
[41:46] N'hésite pas à nous donner des niches,
[41:48] on est preneurs.
[41:50] Viens en DM sur Insta,
[41:52] je t'en donne 10, tout de suite.
[41:54] Avec des niches, quand tu regardes autour de toi, tu en as 10.
[41:56] Viens en DM sur des niches,
[41:58] des niches qui marchent toutes.
[42:00] De 1, du coup,
[42:02] j'imagine que tout le monde va
[42:04] se lancer dessus.
[42:06] En fait, c'est vraiment juste...
[42:08] On peut brainstormer ensemble,
[42:10] il y a un atelier recherche de niches.
[42:12] C'est vraiment...
[42:14] Il y a vraiment tout.
[42:16] Et tu vois, tu me dis, les caméras
[42:18] pour inspecter des tuyaux, est-ce qu'il y a des gens qui achètent ça ?
[42:20] Oui. Après, il faut savoir comment le packager,
[42:22] le marketer.
[42:24] Moi,
[42:26] ça ne me dérange pas parce qu'en vrai,
[42:28] c'est vrai qu'au début, j'ai galéré de fou.
[42:30] Et là, maintenant, ça devient plus lisse.
[42:32] Et puis, je me sens maintenant faire des shops
[42:34] sur des niches et tout. Mais quand tu respectes...
[42:36] Imaginons un mec qui vient d'arriver
[42:38] à la formation, il comme boss,
[42:40] il va dans le module recherche de niches,
[42:42] je te promets, il pète sa tête.
[42:44] Après, c'est bien, tu vois, les arbres à chat,
[42:46] aujourd'hui, ça se vend toujours, tu vois.
[42:48] Mais tu tournes en rond, en vrai.
[42:50] Et du coup, enfin, je ne sais pas, après...
[42:52] C'est une petite réflexion
[42:54] pour vous, quoi.
[42:56] Non, mais je vais le faire remonter,
[42:58] je vais réfléchir. Mais c'est vrai qu'en fait,
[43:00] on est tous passés par là.
[43:02] C'est-à-dire qu'au début,
[43:04] tu te dis, mais c'est impossible de trouver une niche.
[43:06] Et maintenant, moi, personnellement,
[43:08] quand on parle, c'est vraiment le truc
[43:10] où je ne passe pas
[43:12] 1000 ans. En une journée, je te fais une liste
[43:14] de 50 niches potables. Et parce que
[43:16] c'est aussi un muscle
[43:18] à travailler
[43:20] et d'arriver à
[43:22] justement casser un peu
[43:24] et ouvrir ses chakras pour se dire
[43:26] effectivement...
[43:28] C'est un peu incomparable d'un mec qui cherche
[43:30] un métier. Tu vois, dans le sens où,
[43:32] par exemple, les mecs au lycée, par exemple,
[43:34] quand ils cherchent des métiers dans la voie traditionnelle,
[43:36] ils vont se dire, ah, mais voilà, il n'y a pas d'idée,
[43:38] tout le monde fait les mêmes métiers.
[43:40] Mais en soi, il y a des mecs qui vont
[43:42] être consultants en thermodynamique,
[43:44] il y a des mecs qui vont être... Tu vois, il y a plein...
[43:46] C'est tellement vaste
[43:48] qu'il faut juste que tu sors du
[43:50] cercle un peu...
[43:52] Voilà.
[43:54] Tristan, je voulais savoir, j'avais levé la main
[43:56] tout à l'heure, mais du coup, vu que j'ai allumé le micro,
[43:58] ça a coupé le... Enfin, ça a
[44:00] rompu l'ordre du truc.
[44:02] Je ne sais pas si...
[44:04] Bon, allez, exceptionnellement, vas-y, mais ce que j'allais
[44:06] dire, les gars...
[44:08] On n'aurait pas respect pour ceux qui attendent
[44:10] gentiment l'ordre.
[44:12] Vu que j'ai allumé le micro pour répondre
[44:14] aux collègues, ça a
[44:16] rompu. J'étais numéro 2, donc je ne sais pas s'il y avait
[44:18] quelqu'un avant moi.
[44:20] Ben, vas-y, et après,
[44:22] ça sera Yannick. Dis-moi tout.
[44:24] Tristan, je voulais te poser une question.
[44:26] J'avais un gros souci
[44:28] actuellement sur un shop. Bon, pour te donner
[44:30] une idée, c'est le dernier en date que je t'ai envoyé sur le
[44:32] school, enfin, en DM. En fait,
[44:34] le shopping ne spende pas, mais genre
[44:36] vraiment pas rien. Il y a
[44:38] une trentaine, entre
[44:40] 30 et 90 impressions par jour.
[44:42] Tout est nickel. Ça fait plus
[44:44] de 15 jours que le GMC est passé.
[44:46] Je fais à peu près 2-3 clics par jour.
[44:48] J'ai essayé d'enlever l'enchère.
[44:50] J'ai tout essayé. J'ai lancé une feed-only.
[44:52] J'ai lancé une autre shopping.
[44:54] Et à chaque fois, c'est la même, en fait. Ça ne spende pas.
[44:56] Alors, attends
[44:58] que je reprenne ton shop. Et toi, tu es
[45:00] abonné avec Thomas...
[45:02] Ouais, moi, ce que j'allais
[45:04] dire, est-ce que
[45:06] tu as une grosse différence d'offre avec
[45:08] tes concurrents ou pas ?
[45:10] Je suis 15 euros moins cher sur tous les produits.
[45:12] Ouais, ce n'est pas le même problème.
[45:14] Ce n'est pas le même cas que moi. Moi, je suis dans le même cas,
[45:16] mais pas pour la même raison,
[45:18] je pense, du coup. Ouais, mais si tu veux, c'est une niche
[45:20] qui est très... Ouais, il y a beaucoup de
[45:22] produits. C'est très recherché. On va
[45:24] dire que c'est comparable un peu à Luminaire,
[45:26] on va dire, tu vois. Mais oui,
[45:28] c'est bon. J'ai en mémoire ton shop.
[45:30] Ben non, je connais
[45:32] quelqu'un qui était sur
[45:34] cette thématique avant de se faire ban sur un GMC
[45:36] et qui avait...
[45:38] qui n'avait aucun problème. Donc,
[45:40] je sais que ça se peine. Là, tu as
[45:42] un souci, ouais, dessus.
[45:44] Tu sais, ça peut venir d'où ou pas ? Parce que
[45:46] vraiment, j'ai...
[45:48] T'as quoi ? T'as des impressions ?
[45:50] Ouais, j'ai, on va dire, entre
[45:52] 30 et 100 impressions par jour. Aujourd'hui,
[45:54] j'en ai fait 200. Mais
[45:56] je veux dire, en search, il n'y a aucun souci.
[45:58] Je lance une search, ça se peine très bien.
[46:00] Je lance une PMAX Feed Only, ça ne marche pas.
[46:02] Je lance une Shopping, ça ne marche pas. Enfin, genre, ça se peine
[46:04] genre 1 euro tous les jours.
[46:06] Ou 2 euros max.
[46:08] Et ça fait combien de temps que cette campagne, elle tourne ?
[46:10] Cinq jours.
[46:12] Ah, bah oui, mais vas-y, mais attends, on en reparle
[46:14] dans deux semaines. Ah, c'est normal
[46:16] au tout début ?
[46:18] Même, ça peut mettre, ouais, 7 jours avant de partir.
[46:20] Pendant 7 jours, il peut faire du...
[46:22] Mais généralement, tu devrais avoir
[46:24] une progression. Ouais.
[46:26] Le premier, ça dépense 20 centimes. Le deuxième jour, ça dépense
[46:28] 40 centimes. Le troisième jour, ça dépense
[46:30] 1 euro. Quatrième jour...
[46:34] Demain ou après-demain ou dans quelques jours,
[46:36] t'inquiète, ça va partir...
[46:38] Comme un folie.
[46:40] Ça, je me disais, je pensais avoir un problème, donc
[46:42] c'est bon, en tout cas, il n'y a pas de souci. Ouais, je vois une légère
[46:44] progression dans le sens où j'ai fait,
[46:46] on va dire, 50 vues, 100 vues
[46:48] et 200 vues. Parfait.
[46:50] Ça va partir pleine balle d'ici quelques jours.
[46:52] Ok.
[46:54] Je me reste un jour,
[46:56] je me dis, je ne sais pas ce qu'il va apprendre avec 100 vues par jour,
[46:58] il n'apprend rien du tout, le mot.
[47:00] Non, mais c'est normal, ça, ça met toujours un peu de temps
[47:02] à partir au tout début. Ok, merci.
[47:04] Et je suis désolé si j'ai pris la place de quelqu'un.
[47:06] Il n'y a pas de souci. Du coup, il y a
[47:08] Yannick, je te laisse prendre la suite. Juste moi, du coup,
[47:10] vu que j'ai parlé, j'étais troisième,
[47:12] ça m'a enlevé la... Ouais, je me retiens,
[47:14] je retiens. Ah, voilà.
[47:16] Vas-y, Yannick.
[47:18] Ouais, salut tout le monde. Salut, Tristan.
[47:20] Du coup, moi, j'avais une question, c'était par rapport au GMC.
[47:22] Là, mon GMC vient de se faire
[47:24] valider, mais je me souviens que tu avais
[47:26] dit, en gros, quand le GMC
[47:28] se fait valider dans un premier temps, il ne s'est pas vraiment
[47:30] validé, mais il faut voir d'abord dans les campagnes shopping
[47:32] gratuites, comment ça se passe, puisque j'ai oublié
[47:34] le processus. Bah, tu tapes
[47:36] juste ton nom. Par exemple, tu vois, moi,
[47:38] tipee plusloincabane.com, sans le tirer,
[47:40] tu vois, sans l'URL exact, tu vas dans l'onglet
[47:42] shopping, et dès que tu verras tes
[47:44] produits apparaître là-dedans, ça sera bon signe
[47:46] pour savoir que Google
[47:48] a bien
[47:50] transformé ton flux
[47:52] de données en produits
[47:54] visibles sur les réseaux shopping.
[47:56] D'accord. Et dès qu'on voit nos
[47:58] produits dans, du coup,
[48:00] dans le canal gratuit,
[48:02] du coup, ça veut dire que c'est vraiment clair, en gros,
[48:04] il n'y a plus de problème. Ouais.
[48:06] Même si c'est avant les deux semaines, tu as mon approbation pour
[48:08] savoir. D'accord, super, super.
[48:10] Bon, bah, c'était tout.
[48:12] Pas de souci.
[48:14] J'ai fini, tu peux enchaîner.
[48:16] Ouais, Tristan, juste, petite
[48:18] question, il y a une boutique, là, que je suis en train de lancer,
[48:20] pour laquelle je sais qu'il y aura beaucoup de B2B,
[48:22] et par rapport
[48:24] à ça, je me demandais, du coup,
[48:26] que je mette en
[48:28] place, tu sais,
[48:30] le devis, et du
[48:32] coup, à ce niveau-là, je voulais savoir si Shopify proposait
[48:34] des choses, et si toi, tu savais un peu
[48:36] plus, si tu t'étais déjà lancé dans Denix,
[48:38] B2B.
[48:40] Parce qu'en soi, j'ai un concurrent qui propose
[48:42] ajout au panier
[48:44] et faire un devis, et
[48:46] il doit sûrement avoir une option virement, sauf que j'ai jamais fait ça
[48:48] avant, c'était plus classique, Paypal, etc.
[48:50] Et du coup, je voulais savoir si
[48:52] toi, tu... On va dire
[48:54] que, ouais, le plus simple pour commencer,
[48:56] c'est, tu...
[48:58] Alors, j'ai déjà vu des gens qui font
[49:00] en gros, un produit
[49:02] devis, tu vois, que les gens ajoutent au panier
[49:04] à zéro euro, et donc toi, tu reçois
[49:06] la commande, je te recommande absolument pas de faire ça,
[49:08] fais-toi une page avec
[49:10] un formulaire de contact, tu vois,
[49:12] tu fais un espace pro,
[49:14] d'ailleurs, tu peux aller regarder
[49:16] le site Lumires,
[49:18] désolé pour tous les gars qui sont dans la décoration, mais en même temps,
[49:20] c'est un peu la niche la plus obvious
[49:22] du monde,
[49:24] Lumires, L-U-M-E-E-R-S,
[49:26] je vais t'envoyer le lien,
[49:28] tu pourrais aller checker ce qu'ils ont mis en place, parce qu'effectivement,
[49:30] ils ont beaucoup de B2B,
[49:32] et donc là, quand tu vas dans...
[49:34] Enfin, ils ont vraiment un espace pro,
[49:36] mais tu vois, dans deux mondes et un devis,
[49:38] quand tu cliques dessus, en fait, tu arrives sur un
[49:40] formulaire de contact. Ça, tu vois, tu le crées
[49:42] sur une page, en ligne,
[49:44] voilà, juste le mec,
[49:46] tu lui demandes des informations,
[49:48] et ce que je te recommande, pour le
[49:50] virement bancaire, c'est tout simplement,
[49:52] tu lui envoies le devis, lui va te le valider
[49:54] par mail, et après, tu lui dis,
[49:56] est-ce que vous souhaitez que
[49:58] je vous crée un... enfin, est-ce que vous souhaitez
[50:00] payer par carte, mais généralement, ça les arrange pas,
[50:02] auquel cas, je vous crée un produit
[50:04] personnalisé sur la boutique au montant de la commande
[50:06] et vous payez par carte, sinon, tu lui
[50:08] dis, bah, de payer par virement bancaire,
[50:10] allez, tu mets ton div professionnel
[50:12] directement par mail, tu gères ça par mail.
[50:14] Ok. Ok, ok.
[50:18] Euh...
[50:20] Ouais, j'avais juste une autre question,
[50:22] c'était dans des lives qui datent un peu,
[50:24] mais il y en a qui ont eu des
[50:26] légers banns où leur
[50:28] GMC a été mis en pause parce qu'il fallait faire une
[50:30] vérification de l'annonceur, et je voulais
[50:32] savoir, à ce niveau-là, si on pouvait l'anticiper,
[50:34] la faire avant qu'on ait ce genre de problème.
[50:36] Je parle sur le
[50:38] GMC ou sur le Google Ads ?
[50:40] Euh... GMC, je crois, je sais pas.
[50:42] Là, j'ai fait passer mon site au GMC,
[50:44] du coup, j'essaie d'anticiper le plus de choses
[50:46] possibles, et être sûr que ça passe
[50:48] comme il faut.
[50:50] Alors, à ma connaissance,
[50:52] non, sur le GMC.
[50:54] Google Ads, oui. Tu peux aller
[50:56] dans annonces,
[50:58] enfin, sur paiement, dans admin,
[51:00] et t'as une option validation de l'annonceur
[51:02] pour le faire en amont
[51:04] avant que t'aies un problème.
[51:06] Je connais le compte de paiement.
[51:08] Dès que j'ai mis mes informations de paiement,
[51:10] je me suis mangé la vérif, genre, deux heures après.
[51:12] Parce que tu peux peut-être anticiper.
[51:14] Mais dans tous les cas, il y a Google Ads qui te met un message
[51:16] en mode, si tu fais pas dans cinq jours,
[51:18] tes pubs s'arrêtent, mais du coup, ils te présentent.
[51:20] Le mieux,
[51:22] c'est de le faire vraiment à la création du site.
[51:26] Même une petite astuce qui peut
[51:28] être pas trop mal, c'est quand vous créez un compte
[51:30] Google Ads, vous faites un paiement manuel
[51:32] de 5 ou 10 euros sur le compte directement.
[51:36] De toute façon, ils prélèvent, Google,
[51:38] quand tu rentres des informations de paiement ?
[51:40] Non. Ils te font juste une vérif à zéro euro,
[51:42] mais toi, t'as la possibilité de recharger manuellement.
[51:44] Tu peux mettre 5 euros sur ton compte Google Ads,
[51:46] et t'en mettre des campagnes.
[51:48] Tu vois, juste tu vas
[51:50] effectuer un paiement
[51:52] et tu peux déjà recharger ton compte
[51:54] pour mettre de l'argent dessus. C'est une bonne pratique.
[51:58] Let's go.
[52:00] Avant de te donner la parole, Thomas, parce que t'étais
[52:02] dans la file d'attente, je prends quelques questions
[52:04] écrites, sinon on va les appeler.
[52:06] Ah oui, il y en a
[52:08] une blinde.
[52:14] Valentin, salut, je vois ce petit problème,
[52:16] j'ai fait correctement la meta description, et quand
[52:18] je mets sur interne le nom du shop.com,
[52:20] tous mes liens,
[52:22] tous mes liens, ce n'est pas du tout.
[52:24] Valentin, c'est normal, Google
[52:26] depuis trois ans,
[52:28] on fait caisse à tête avec les meta descriptions.
[52:30] Donc là, en fait, il faut que tu regardes ce que Google a récupéré
[52:32] comme contenu de ta page, parce que Google, il n'invente pas
[52:34] les meta descriptions. Il récupère une partie dans ta page
[52:36] et en fait, il faut que tu regardes
[52:38] ce qu'il a récupéré et que tu le reformules un peu.
[52:40] Et s'il l'a récupéré, ce n'est pas par hasard, c'est que
[52:42] ta meta description ne lui plaisait pas,
[52:44] elle ne décrivait pas suffisamment le contenu de la page pour lui.
[52:46] Donc, sers-toi de ce qu'il a récupéré,
[52:48] lui, pour reformuler ta meta description.
[52:50] Mais,
[52:52] ce n'est pas une optimisation,
[52:54] enfin, ne perds pas trop de temps là-dessus.
[52:56] La balise sur Google,
[52:58] H, ajout au panier paiement initié, est-il
[53:00] obligé de faire une simulation pour qu'elle soit bien activée
[53:02] ou on peut laisser en état mauvaise configuration ?
[53:04] Zephine, tu peux la laisser en état mauvaise configuration
[53:06] et normalement, si tout est bien configuré,
[53:08] dès que tu as
[53:10] une vente,
[53:12] un autre jeu panier ou un paiement initié,
[53:14] ça va automatiquement passer en
[53:16] éligible. Sinon, tu peux cliquer sur
[53:18] dépannage et tu peux la déclencher toi-même avec
[53:20] Tag Assistant Legacy
[53:22] et ça enlèvera la mauvaise configuration.
[53:24] On va dire que c'est une bonne pratique pour
[53:26] éviter de perdre,
[53:28] enfin, si tu attends 2-3 jours et que tu te rends compte
[53:30] que tu as fait des ventes mais que ça ne remonte pas, autant le vérifier à la main.
[53:32] Ok.
[53:34] Il y a encore de nouveaux modules qui sortent ?
[53:36] Oui, c'est en cours. Notamment
[53:38] sur la partie Ads.
[53:40] On va aller loin dans la partie Ads.
[53:42] La partie tracking et également
[53:44] une partie netlinking sur le SEO.
[53:50] Je vois des politiques
[53:52] du type politique RGPD ou ne pas vendre
[53:54] ou ne pas partager de données. Est-ce que c'est important pour le GMC ?
[53:56] Pourquoi certaines boutiques ont ça
[53:58] alors que toi tu n'en parles pas ?
[54:00] Il faudrait peut-être que je mette à jour
[54:02] les coordonnées
[54:04] mais en tout cas,
[54:06] à ma connaissance, je le redis sur les questions
[54:08] politiques, etc. Je ne suis pas avocat.
[54:10] Moi en tout cas, je les avais fait rédiger il y a un moment
[54:12] par une avocate compétente
[54:14] et je ne les avais pas.
[54:16] Donc
[54:18] la politique RGPD,
[54:20] qu'on appelle gestion des cookies,
[54:22] elle peut être gérée par votre application tierce.
[54:24] En fait, il faut juste que vous ayez une page où la personne
[54:26] peut gérer son consentement à n'importe quel moment
[54:28] et ne pas vendre ou partager mes données. Je crois,
[54:30] si je ne dis pas de bêtises, que c'est uniquement destiné au marché américain
[54:32] par français. Mais bon, je ne veux pas m'avancer sur
[54:34] ces sujets-là et je creuserai effectivement
[54:36] si c'est incomplet.
[54:38] Les politiques ne
[54:40] pas vendre et tout et j'ai passé le GMC.
[54:42] Oui, mes politiques, je valide
[54:44] encore mes shops actuellement, il n'y a aucun souci.
[54:46] Côté GMC, c'est ça qui vaut.
[54:48] Par contre, le côté légal, je ne m'engage pas dessus.
[54:50] Allez Thomas, tu vas pouvoir
[54:52] enchaîner.
[54:54] Ouais, bah moi écoute,
[54:56] du coup, on a un peu changé notre
[54:58] vision avec Lisa. On est enfin sortis
[55:00] de ce mood SEO long terme.
[55:02] Je pense que ça nous a cassé la tête.
[55:04] On s'est pris plusieurs jours
[55:06] en train de
[55:08] chercher des niches. On est quasiment sûrs
[55:10] que celles-là vont marcher.
[55:12] On a tous nos
[55:14] vérifs qui sont bonnes. Donc là,
[55:16] on veut passer vraiment en mode usine.
[55:18] Est-ce que
[55:20] tu aurais
[55:22] des process à recommander à ce niveau-là ?
[55:24] Genre vraiment
[55:26] plus attarder sur les petits
[55:28] détails. Bien sûr, faire un minimum.
[55:30] Mais vraiment,
[55:32] maintenant qu'on a des niches, qu'on est
[55:34] sûrs quasiment, bon, on peut jamais être sûrs
[55:36] à 100%, on t'a capté, mais qu'on
[55:38] a de bons voyants.
[55:40] Tu vois, on préfère enchaîner,
[55:42] faire plein, plein, plein de niches
[55:44] qu'être en mode perfectionniste, en mode
[55:46] SEO, et t'as qu'un shop
[55:48] au final d'en avoir 10.
[55:50] Donc là, on l'a fait pour les premières niches,
[55:52] mais pour les prochaines, on ne veut pas. Est-ce que tu as des process
[55:54] à recommander à ce niveau-là ? Je sais que
[55:56] moi aussi, je suis un peu dans ce délire.
[55:58] Donc voilà, on est preneurs.
[56:00] Moi, ce que je te recommande
[56:02] quand même, même si tu as envie de partir sur un
[56:04] sur la méthode
[56:06] usine, c'est quand même
[56:08] de te mettre un target peut-être
[56:10] de 2-3 shops, tu vois, où vraiment
[56:12] tu fais le truc bien, mais vraiment.
[56:14] Mais bien dans le sens ad, c'est-à-dire que
[56:16] tu vois, le SEO, et je te dis, on vient
[56:18] de la même école, donc je sais, tu passes beaucoup de temps
[56:20] sur Urtex Guru, etc.,
[56:22] mais ce n'est pas ça qui va te faire vendre sur Google.
[56:24] En vrai, c'est plus de vraiment bien décomposer,
[56:26] tu vois, une fiche produit.
[56:28] Toi, la partie qui va peut-être te manquer,
[56:30] sur laquelle il va falloir que vous bossiez,
[56:32] ça va être vraiment la partie
[56:34] tout ce qui est copywriting,
[56:36] bien agencer une fiche produit, bien comprendre.
[56:38] Et voilà, fais
[56:40] 3 shops où tu mets vraiment de l'amour,
[56:42] tu mets vraiment du tiens, etc.
[56:44] Et une fois que tu as ces 3-là, en fait, il faut vraiment
[56:46] que tu chopes la tambouille. Dès que tu as la tambouille,
[56:48] là, tu passes en mode usine. Mais ne passe pas en mode usine maintenant.
[56:50] Pourquoi ?
[56:52] Tu veux dire
[56:54] dans quel but
[56:56] il faut faire les 3 premiers carrés ?
[56:58] Dans le but où, dès que tu passes
[57:00] après sur l'automatisation, make and retain,
[57:02] tu as une vision très claire de ce que tu veux faire,
[57:04] ok, il y a ma fiche produit, il y a mon titre qui est là,
[57:06] mes étoiles qui sont là, il y a une petite description
[57:08] de deux lignes qui est là, il y a mon bouton à toutes cartes,
[57:10] là, ok, je suis sur la niche
[57:12] décoration, donc il va falloir que je mette en avant
[57:14] les spécificités. Donc ici, je fais un tableau
[57:16] avec caractéristiques, centimètres et tout, je me crée
[57:18] les métaphines, bam, bam, bam. Tout ça, tu le développes,
[57:20] cette gymnastique mentale, tu la développes en faisant
[57:22] le truc à la mano. Une fois que tu as le truc,
[57:24] tu sais où tu veux aller,
[57:26] tu sais quoi automatiser.
[57:28] Donc, dans un premier temps, fais-le
[57:30] un peu à la main et pas dans cet objectif
[57:32] usine. Mets-toi
[57:34] une target de chiffre d'affaires et de bénéfices
[57:36] et une fois que tu as la sauce,
[57:38] ça, une fois qu'en fait,
[57:40] il faut le débloquer pour pouvoir le dupliquer.
[57:44] Et c'est un modèle qui est quand même différent que le SEO.
[57:46] C'est pour ça que je te dis ça. Ouais, c'est ça. Franchement,
[57:48] on a du mal à s'en sortir.
[57:50] Tu es très bien placé pour le savoir.
[57:52] Mais ouais, on aimerait vraiment sortir
[57:54] de ça, ça serait le but.
[57:56] Sachant que vraiment, en ce moment, le SEO,
[57:58] c'est... Moi, je relance des sites
[58:00] SEO et tout, c'est
[58:02] incompréhensible en ce moment ce qui se passe.
[58:06] Mais c'est ouf maintenant, en fait,
[58:08] les critères sociaux.
[58:10] Avoir du trafic en dehors de Google, comment c'est hyper
[58:12] important. Moi, j'ai vu des SERP,
[58:14] mais un truc,
[58:16] je peux te donner la niche,
[58:18] tu pourrais aller regarder les nids d'anges pour bébés.
[58:20] Le premier,
[58:22] si ça n'a pas changé, le gars, son site,
[58:24] il est explosé en SEO.
[58:26] Et le mec, il rank parce qu'en fait, il a un
[58:28] petit stock qui fait des millions de vues.
[58:30] Et en fait,
[58:32] c'est le trafic TikTok qui le fait ranker.
[58:34] Donc, en ce moment, il y a des SERP improbables.
[58:36] J'ai un shop qui est ranké
[58:38] troisième, juste derrière Jouer Club et
[58:40] King Jouer. Enfin, bref,
[58:42] les trucs de jouets. Juste parce que du coup, j'ai un
[58:44] compte TikTok qui fait des vues.
[58:46] Et genre, je suis ranké. C'est insane.
[58:48] Je n'ai aucun blog, je n'ai rien.
[58:50] Je n'ai rien et le site,
[58:52] il me fait des ventes genre tous les jours.
[58:54] Ça sonne juste en full SEO
[58:56] et je ne suis même pas premier, je suis quatrième.
[58:58] L'algo SEO,
[59:00] il éclate. Non, mais moi, enfin,
[59:02] moi, franchement, je ne cherche plus à comprendre.
[59:04] Là, c'est pour ça, je te parle comme ça.
[59:06] Je te dis, je veux vraiment changer de
[59:08] système parce que, enfin, ce n'est pas
[59:10] je ne fais plus confiance au SEO. Le SEO a changé ma vie,
[59:12] tu vois, depuis 5-6 ans. Mais là,
[59:14] les nouveaux sites,
[59:16] je compte plus clairement
[59:18] sur le SEO. Ou alors, c'est juste
[59:20] un bonus, pourquoi pas,
[59:22] tu vois, le petit 10-20%.
[59:24] Mais genre, vraiment, le SEO,
[59:26] je ne compte plus dessus pour en faire de l'argent
[59:28] sur un long terme.
[59:30] Après, la bonne vision
[59:32] pour moi à avoir, et mon associé était
[59:34] un peu parti comme toi, tu vois,
[59:36] où je lui disais, ah, mais vas-y, on va quand même mettre un...
[59:38] Et je me disais,
[59:40] non, non, vas-y, on s'en fout du SEO
[59:42] et tout, etc. Je lui disais, bah non. Mais la bonne vision à avoir
[59:44] pour moi, c'est de te dire
[59:46] l'avantage de Google Ads, c'est que tu peux chiffrer
[59:48] day one. L'avantage du SEO,
[59:50] c'est que derrière, tu vas aller chercher des marges
[59:52] que tu connais, où tu fais des 80 000 euros
[59:54] CA par mois et tu te mets 60 000 balles dans la poche.
[59:56] Ça, tu peux le faire grâce au SEO.
[59:58] Ouais, mais c'est extrêmement plus long qu'avant,
[60:00] je trouve. Tu te rappelles les chiffres que je t'avais
[60:02] montré mon premier show, mais ça,
[60:04] ça chiffrait déjà en trois mois, quand un SEO, c'est ouf.
[60:06] Non, non, mais toi, t'es une
[60:08] anomalie. Ça, je te le dis,
[60:10] t'es une anomalie. Mais pour ranker,
[60:12] waouh, c'est de la folie, quoi.
[60:14] Donc, ouais, moi, je vais m'arrêter
[60:16] au SEO de base, du coup,
[60:18] c'est bien parce qu'il en faut, ouais, pour le
[60:20] GMC, mais pas aller
[60:22] plus loin, quoi.
[60:24] Ok, ok. Bah après,
[60:26] du coup, donc, la solution long
[60:28] terme d'automatisation en mode usine,
[60:30] entre guillemets, donc c'est N8M, c'est ça ?
[60:32] Tu fais comme ça, toi ?
[60:34] Tu peux avoir de bons résultats sur Make, ou tu peux regarder,
[60:36] je sais pas si t'as vu la méthode reboot,
[60:38] la vidéo que je parle dans la formation,
[60:40] où t'as le fichier Google Sheets pour
[60:42] déjà gagner pas mal de temps sur la partie
[60:44] rédaction, ouais. Tu plug un cloud,
[60:46] tu te fais un bon prompt,
[60:48] tu mets la colonne jusqu'en bas, tu rédiges
[60:50] tout d'un coup, et puis...
[60:52] C'est déjà passé par ça. C'est quelle vidéo ?
[60:54] Dans le module
[60:56] GMC, c'est méthode reboot.
[60:58] Ok, vas-y,
[61:00] je vais voir. Ah, j'ai pas vu un
[61:02] encore tes vidéos. Ouais, t'as accès aux tools,
[61:04] t'as accès à tout, tu le plug en API
[61:06] à cloud, j'ai tout expliqué dans la vidéo.
[61:08] Ok. Ça sert de ça, déjà, ça sera
[61:10] un premier pas. Mais quand tu voudras passer vraiment
[61:12] sur de l'usinage,
[61:14] et encore, tu vois, de l'usinage, c'est pas tout le temps possible.
[61:16] Nous, on est en train de
[61:18] lancer un shop niche
[61:20] type décoration, et là,
[61:22] on y va en mode usine bourrin, on est en train de créer
[61:24] des scripts et des automatisations, mais
[61:26] demain, si je lance un correcteur de posture,
[61:28] mais jamais de la vie, je le fais en automatisation,
[61:30] je creuse le personnel,
[61:32] je fais une fiche produit,
[61:34] je génère de la vidéo,
[61:36] ou même, tu vois,
[61:38] un produit un peu tendance
[61:40] winner, il y a le robot de la vitre,
[61:42] je peux le dire maintenant, parce qu'il y a tellement
[61:44] de personnes de plus que moi. Ouais, j'ai vu, ouais.
[61:46] Tu vois,
[61:48] c'est le genre de produit où tu ne peux pas
[61:50] automatiser. Ok.
[61:52] T'es obligé de faire une description fournie,
[61:54] de bien comprendre l'avatar,
[61:56] donc ça dépend, en fait, ça dépend vraiment de ce que tu veux faire.
[61:58] Mais tu vois, toi, dans la typologie
[62:00] de niche, et la typologie de type,
[62:02] si tu as un site que tu as pu développer en SEO qui marche très très bien
[62:04] Google Ads, que sur du volume de catalogue,
[62:06] c'est possible d'automatiser, mais dans un premier
[62:08] temps, vraiment, fais-le bien, je te conseille.
[62:10] Ouais, pour avoir mes retards. Pour en faire deux, trois, carrément.
[62:12] Et quand tu parlais des
[62:14] contacts, les engines, tout ça,
[62:16] ça a un avoir avec ça ? C'est une autre technique, non ?
[62:18] Pour le plus ?
[62:20] Ouais, c'est différent, en fait, c'est que la seule partie
[62:22] qui n'est pas automatisable dans ce
[62:24] business-là,
[62:26] en fait, moi, c'est parce que c'est des sites
[62:28] qui n'existent pas, c'est des sites d'affiliation,
[62:30] donc, en fait, il faut... Ah !
[62:32] La main, il faut copier-coller les informations de nos
[62:34] sites affiliés, les mettre dans le Shopify,
[62:36] et après, il faut tout rédiger en mode SEO.
[62:38] Parce que là, pour le coup, vraiment, nous, on ne fait que du...
[62:40] sur de l'affiliation où je gagne 10%
[62:42] sur une vente, je ne vais pas faire du Google Ads, tu vois.
[62:44] Donc, on fait exclusivement du SEO.
[62:46] Mais, du coup,
[62:48] en fait, si tu veux, demain, si je crée un
[62:50] shop sur une niche et que je n'ai pas
[62:52] de concurrent Google Ads où je peux scraper leurs produits,
[62:54] ben, je vais être obligé
[62:56] d'avoir un opérateur humain qui va aller
[62:58] chercher lui-même les produits pour les intégrer.
[63:00] Disons qu'un Indien qui travaille pour 4 balles de l'eau,
[63:02] c'est plus rentable que moi qui vais passer
[63:04] 20 heures à faire ça à la main.
[63:06] Donc, ça, je le délègue, oui.
[63:08] Ok, ok, ça marche. Après, le côté
[63:10] description et images produits,
[63:12] ça, vraiment, je pense qu'on peut le pousser.
[63:14] C'est ce que je suis en train de faire actuellement.
[63:16] Là, j'ai...
[63:18] J'ai toujours Cloud Cohort ouvert
[63:20] en permanence et maintenant, ben,
[63:22] je m'en sers pour, par exemple, dupliquer
[63:24] certaines... enfin,
[63:26] certains styles de copywriting.
[63:28] Je peux sortir, genre, une
[63:30] trentaine, quarantaine de descriptions
[63:32] de produits fournis avec des bullet points,
[63:34] des SVG ultra propres,
[63:36] bref, en gros, des descriptions
[63:38] propres dignes d'un site
[63:40] qui fait plusieurs millions, soit pas
[63:42] un pavé de texte en
[63:44] teen-news romans.
[63:46] Et ça, vraiment, on peut en sortir, genre,
[63:48] trente, quarante en même pas une heure grâce à
[63:50] Cloud Cohort, genre, qui va scraper
[63:52] les fiches AliExpress, qui va récupérer
[63:54] les données sur Amazon, tout seul, hein,
[63:56] 100% tout seul, et c'est ce que je suis en train de développer
[63:58] actuellement. Et la partie qui me manque,
[64:00] c'est juste la partie images produits, mais
[64:02] après, le côté usine, là où je le trouve
[64:04] vraiment pertinent, c'est pour
[64:06] ajouter beaucoup de produits,
[64:08] plus que créer beaucoup de sites.
[64:10] Je suis d'accord,
[64:12] je suis d'accord avec toi, moi, mais en fait,
[64:14] dans le processus que tu décris,
[64:16] même si Cloud Cohort a la possibilité d'aller scraper
[64:18] lui-même les informations, etc., ça reste quand même
[64:20] manuel versus un
[64:22] ou un mec qui va booter en boucle
[64:24] jusqu'à faire tes mille produits que tu as
[64:26] sur ton site,
[64:28] et ça reste, pour moi,
[64:30] ça reste quand même assez manuel dans le sens où
[64:32] même l'essence, c'est quand même
[64:34] d'arriver à comprendre, parce que même si Cloud fait des choses
[64:36] bien, tu es toujours obligé
[64:38] de repasser derrière ta fiche, ajuster
[64:40] quelques mots, ajuster quelques copywritings,
[64:42] etc. C'est ça que je dis dans le sens où
[64:44] tu ne peux pas faire de l'usinage sur ce genre de site.
[64:46] Pas encore.
[64:48] Oui, c'est vrai qu'il faut toujours passer un peu derrière, oui.
[64:50] Mais, ouais.
[64:52] C'est clair que tu peux gagner 80% de temps
[64:54] en faisant ton template,
[64:56] et même moi, je vais te le dire,
[64:58] Cloud Cohort, tu lui crées un projet
[65:00] avec ton thème, tu lui dis
[65:02] d'aller explorer les fichiers JSON,
[65:04] de comprendre chacun de tes sections,
[65:06] et sur ton thème, tu peux lui dire
[65:08] de construire
[65:10] un modèle de page.
[65:12] Exactement.
[65:14] Donc, lui, il va créer Product 2, et lui, il va formater
[65:16] tout le JSON. C'est incroyable.
[65:18] Oui, c'est ça. Et puis, en plus,
[65:20] si on mêle ça avec créer ses propres sections,
[65:22] ça peut faire vraiment du sale,
[65:24] un peu comme les sections table,
[65:26] par exemple, je vends des casques audio,
[65:28] je vais créer une table par feature,
[65:30] et je vais connecter ça à JSON, bien sûr.
[65:32] Mais après, comme tu dis, j'ai déjà essayé,
[65:34] et il faut repasser derrière.
[65:36] C'est ça. Donc, l'usinage n'est pas possible.
[65:38] Mais pour te dire,
[65:40] construire un site, par exemple, d'horloge murale,
[65:42] tu peux faire de l'usinage.
[65:44] Tu peux exporter une licence horloge
[65:46] et avoir un bon script
[65:48] qui récupère les caractéristiques, l'image,
[65:50] le prompt. Pour vendre une horloge,
[65:52] tu n'as pas besoin de jouer trop
[65:54] sur l'émotionnel, tu vois.
[65:56] Oui.
[65:58] Sinon, tu as la technique de GE,
[66:00] on l'a vu en code la dernière fois.
[66:02] Lui, pareil, il fait CloudCore,
[66:04] donc il lui dit,
[66:06] étudie-moi le marché, les points positifs,
[66:08] les points négatifs, fais-moi le persona,
[66:10] etc.
[66:12] Et après, il envoie
[66:14] à Cloud, donc ça, il fait avec CloudCore,
[66:16] et après,
[66:18] il dit de créer un prompt
[66:20] pour CloudCode pour faire le site,
[66:22] par rapport au résultat qu'il a trouvé avant.
[66:24] Donc après,
[66:26] ouais, le truc, c'est que tu dois toujours
[66:28] repasser dessus. C'est ça,
[66:30] c'est une super technique
[66:32] qui t'a partagé,
[66:34] mais derrière,
[66:36] tu as quand même cette partie,
[66:38] c'est complètement génial, tu imagines,
[66:40] je te dis ça avec des mais, mais
[66:42] ça te fait économiser 80%, mais même
[66:44] 80% de ton travail, mais tu ne peux pas
[66:46] usiner, tu peux
[66:48] tu peux
[66:50] déjà partir sur une très bonne base et gagner du temps,
[66:52] mais tu ne vas pas
[66:54] Après, est-ce que tu peux
[66:56] modifier, tu vois,
[66:58] chaque section et tout, est-ce que ça ne te fout pas tout en banque ?
[67:00] Est-ce qu'il ne vaut mieux pas faire du code
[67:02] section par section pour être plus safe, tu vois ?
[67:04] C'est ça le truc, si tu arrives,
[67:06] tu as le site, bon déjà,
[67:08] si tu dois attraper quelque chose
[67:10] au niveau des textes,
[67:12] des designs, c'est ok, mais carrément, si ça te fait
[67:14] des bugs et tout, ce n'est pas ouf.
[67:16] Si tu dois repasser sur tout,
[67:18] il faut que je ne sais pas où...
[67:20] Il faut que ça soit bien intégré à WordPress,
[67:22] il y a moyen de bien le compter pour que ce soit intégré,
[67:24] mais au-delà de ça, Thomas, un autre truc, c'est que
[67:26] demain tu usines, tu m'envoies
[67:28] 10 ou 15 sites, ben va
[67:30] mettre 50 balles de budget
[67:32] par campagne sur 10 sites différents, tu vois.
[67:34] C'est pour ça que je préfère que tu fasses 3 sites
[67:36] bien,
[67:38] même si tu as le budget pour investir sur ces sites-là,
[67:40] franchement, faire du testing sur
[67:42] 10, 15, 20 sites en même temps,
[67:44] pour avoir
[67:46] un peu de réseau, quoi.
[67:48] Ouais, j'ai jamais été dans ce cas-là, tu vois, donc
[67:50] ouais, même niveau
[67:52] suivre tout ça,
[67:54] ouais, c'est chaud, ouais.
[67:56] Bon, ok, vas-y, on va faire étape par étape, déjà,
[67:58] je fais 3 sites,
[68:00] chacun nous-mêmes, tu vois, après on verra.
[68:02] Et ça te donne quoi, là, la search sur ton
[68:04] sur ton shop
[68:06] Siquet ?
[68:08] Il n'y a pas une seule vente, encore, je mets 40 euros par jour,
[68:10] mais c'est compliqué,
[68:12] sur ces niches-là, tu sais, il y a beaucoup d'émotions et tout, donc...
[68:14] Bon, après, je pense que
[68:16] c'est le genre de niche où tu peux avoir un
[68:18] contact maintenant qui te fait une vente dans 4 mois,
[68:20] donc il va falloir avoir les reins
[68:22] un peu solides, je pense, en maths, parce que
[68:24] en fait, entre le moment où la
[68:26] personne voit ton site et le moment où
[68:28] tu vas l'acheter, il y a tellement de temps,
[68:30] tu vas quand même avoir rené des ads pendant
[68:32] un moment avant d'avoir ta première vente.
[68:34] Ouais, ils viennent 10 fois, 10-15 fois les clients sur le site avant d'acheter,
[68:36] je pense, ils ont vu toutes les sections
[68:38] du site et tout avant d'acheter, c'est sûr.
[68:40] Mais tu as quand même eu des...
[68:42] tu continues à avoir des demandes de contact tous les jours ?
[68:44] Ouais, j'ai eu 2 messages,
[68:46] bon, on verra ce que ça donne, mais
[68:48] bon, de toute façon, écoute, je laisse tourner,
[68:50] en plus, après, tu sais, j'ai les 400 balles gratuites,
[68:52] donc...
[68:54] Tu fais un beau template de mail,
[68:56] un joli template quand tu réponds,
[68:58] un truc de...
[69:00] Tu veux dire le formulaire de contact ?
[69:02] Non, quand tu...
[69:04] Est-ce que tu as brandé ta partie mail, tu vois ?
[69:06] Ne serait-ce que la signature de...
[69:08] Ah oui, j'ai fait, j'ai fait, je signe bien, tu vois,
[69:10] avec la créatrice de la marque
[69:12] et tout...
[69:14] Génial. Je pense que toi, tu vas avoir...
[69:16] D'ailleurs, les 400 balles, on les a plus ?
[69:18] Enfin, je les ai plus ?
[69:20] Non, non, ils sont toujours existants.
[69:22] Je les ai plus, les 400 balles,
[69:24] sur tous mes nouveaux comptes ads ?
[69:26] Moi, je les ai eu.
[69:28] Putain...
[69:30] Par contre, j'ai eu une demande
[69:32] d'alternance.
[69:34] Ah, mais non, tu n'es pas dans le groupe WhatsApp.
[69:36] Une meuf, elle m'a...
[69:38] Elle m'a envoyé
[69:40] un message de demande d'alternance
[69:42] pour rejoindre l'atelier,
[69:44] la marque.
[69:46] Et là, tu t'es dit, putain, merde, le coup par clic qui est parti dans une demande d'alternance.
[69:48] Ouais.
[69:50] Non, bon, ok.
[69:54] Bon, ok, ben, merci.
[69:56] Et je te tiens au jeu.
[69:58] Tu m'as dit trop bien.
[70:00] On fait ça.
[70:02] Next, OCCN.
[70:04] Je n'ai pas ton nom.
[70:06] Je vais en finir.
[70:08] Salut.
[70:10] Salut tout le monde. Salut, Tristan.
[70:12] Salut, Charles.
[70:14] Ouais, ça va, super.
[70:16] Du coup, en fait, j'avais une question concernant ma boutique.
[70:18] En fait, il y a un produit qui semble assez similaire
[70:20] à une partie de ta boutique d'horloge
[70:22] que tu nous avais montrée.
[70:24] Et en fait, mon problème, c'est que
[70:26] les ventes irrégulières, genre, il peut y avoir
[70:28] un jour où je ne fais rien, mais
[70:30] j'ai l'impression que cette boutique,
[70:32] elle a du potentiel. Et comme je suis en période
[70:34] d'apprentissage, en fait, je me demandais
[70:36] si, en fait, je ne proposais pas assez de produits.
[70:38] Tu as combien de produits ?
[70:40] En fait,
[70:42] sans compter les variantes, j'en ai
[70:44] 22, si on compte les variantes.
[70:46] Ça fait 75, je pense.
[70:48] Ouais, je pense
[70:50] que tu peux démarrer avec ça.
[70:52] Ça fait combien de temps que tu as démarré tes ads ?
[70:54] Euh...
[70:56] OK. En fait, j'avais
[70:58] là, le 1er mai.
[71:00] OK.
[71:02] Et tu as combien de budget
[71:04] là, par jour ?
[71:06] Vraiment, je ne suis pas rentable
[71:08] pour ça, je suis en prison. Enfin, je ne suis pas rentable
[71:10] genre... En fait, c'est
[71:12] pile poil, quoi. Par exemple, c'est...
[71:14] Mais tu as combien de budget
[71:16] que tu dépenses par jour ?
[71:18] Ah, par jour ?
[71:20] Mon budget, j'ai mis
[71:22] à 100. D'abord, c'est à 40.
[71:24] Donc, tu as 100 euros
[71:26] par jour, et ton produit, il coûte combien ?
[71:28] Ton panier moyen ?
[71:30] Mon panier moyen du produit, on peut dire
[71:32] qu'il coûte, OK,
[71:34] 120.
[71:36] Et
[71:38] ta campagne, elle spend 100 euros par jour ?
[71:40] Elle les dépense, les 100 euros par jour ?
[71:42] Euh...
[71:44] Non, ça dépend.
[71:46] OK.
[71:48] Toc, toc, toc. Et
[71:50] tu sais, ton CPC moyen, il est à peu près à combien ?
[71:52] Ah, j'ai mis
[71:54] je l'ai baissé petit à petit, du coup,
[71:56] il est à 33.
[71:58] OK.
[72:00] Là, il y a plusieurs choses dans ce que tu
[72:02] me dis. Déjà,
[72:04] si tu as un produit à 120 euros
[72:06] et que tu limites ton coût par clic à 33,
[72:08] peut-être que tu limites un petit peu trop l'encher
[72:10] et donc que tu récupères des clics de moins bonne qualité.
[72:12] En fait, déjà, après 11 jours
[72:14] de campagne, être break-even, c'est déjà
[72:16] bien. On va dire que
[72:18] dans le sens où, là, ton
[72:20] but, c'est de récolter un maximum de
[72:22] données et passer
[72:24] assez rapidement sur une stratégie
[72:26] maximiser la valeur de conversion. Donc, une fois
[72:28] que tu fais entre
[72:30] les 30 et 50 conversions, dès que tu as 30
[72:32] et 50 conversions sur les 30 derniers jours,
[72:34] à ce moment-là, tu vas pouvoir basculer en
[72:36] en maximiser la valeur
[72:38] de conversion. Et donc, là, à ce moment-là,
[72:40] ton algo, il va peut-être aller chercher des clics à 2
[72:42] ou 3 euros, mais des clics qui sont très qualifiés.
[72:44] OK.
[72:46] Mais disons que sur un lancement
[72:48] de campagne, après 11 jours,
[72:50] être déjà break-even, c'est bon signe.
[72:52] Moi, en tout cas,
[72:54] c'est bon signe.
[72:58] Là, juste optimise bien le CRO de ta boutique.
[73:00] Assure-toi que ton tracking
[73:02] fasse bien remonter la donnée, surtout avec
[73:04] ce que je vous ai montré au début
[73:06] de la vidéo, avec
[73:08] le gateway. Assure-toi que
[73:10] tu ne perdes pas de data et que tu récoltes
[73:12] assez rapidement ces 30 ou 50
[73:14] conversions. Et après, une fois que c'est
[73:16] live, tu vas pouvoir
[73:18] scaler comme ça.
[73:20] Sinon, dans un premier temps,
[73:22] évite de trop toucher
[73:24] à ton CPC max, parce qu'à chaque fois, tu vas
[73:26] faire repartir ta campagne d'apprentissage.
[73:28] Mais ça serait d'essayer de jauger
[73:30] un bon CPC pas trop...
[73:32] C'est-à-dire que le CPC
[73:34] dont ta limite d'enchère ne soit pas trop basse
[73:36] pour ne pas avoir des clics trop merdiques. Elle ne soit pas
[73:38] trop haute non plus pour ne pas exploser
[73:40] ta rentabilité.
[73:42] Donc là, il faut que tu essaies de te mettre
[73:44] dans une fourchette un petit peu au milieu,
[73:46] que tu restes un petit peu plus haut que ta fourchette moyenne, un petit peu plus bas.
[73:48] OK. Parce que... Et essayer de
[73:50] tourner pendant un moment comme ça.
[73:52] Parce que vous avez bien dit que ça dure en fait...
[73:54] Si on change le CPC, vous avez bien dit qu'en fait
[73:56] ça durait genre 5 jours
[73:58] pour le mettre à jour, en fait, non ?
[74:00] En fait, c'est qu'à chaque fois que tu vas faire
[74:02] des grosses modifs, ta campagne, elle va repartir
[74:04] en apprentissage. Parce que sa méthode
[74:06] de...
[74:08] Comment dire... De déploiement
[74:10] avec un CPC à 30 centimes
[74:12] et sa méthode de diffusion,
[74:14] pas déploiement, mais avec un CPC
[74:16] à 50 centimes, elle est complètement différente.
[74:18] Donc quand tu vas faire ce genre de modif,
[74:20] ton page
[74:22] shopping, elle va complètement...
[74:24] Enfin, elle va repasser
[74:26] sur une phase d'apprentissage pour aller
[74:28] essayer de tester des CPC un peu bas,
[74:30] des CPC vers le haut
[74:32] de ta fourchette...
[74:34] Elle va faire du test.
[74:36] OK. Ça marche.
[74:40] Parce qu'en fait, du coup,
[74:42] comme je voulais un peu
[74:44] remplir un peu le site,
[74:46] du coup, j'ai mis en fait
[74:48] d'autres produits. Et je pense aussi que du coup, ça m'a
[74:50] bouffé des CPC, par exemple,
[74:52] sur un autre produit qui n'avait pas
[74:54] le même mot-clé.
[74:56] Et d'où
[74:58] l'importance de bien segmenter.
[75:00] Oui. OK. Ça marche.
[75:02] Donc voilà. Par exemple, les nouveaux
[75:04] produits que tu sors, si tu veux pas faire de la pub dessus,
[75:06] bah, cut-lay au niveau de ta compagnie.
[75:08] Oui, c'est ce que j'ai fait aujourd'hui.
[75:10] OK. Ça marche.
[75:12] Ou alors... Enfin, moi j'aime bien
[75:14] faire... Enfin, laisser quand même
[75:16] le... Enfin, ça dépend si
[75:18] j'ai dépensé 100 euros de pub sur un produit
[75:20] et qu'il s'est pas vendu.
[75:22] Peut-être que je le cut définitivement. Mais disons que
[75:24] j'aime bien quand même
[75:26] ne pas isoler un produit sans l'avoir testé.
[75:28] Mais après... Mais là, c'est encore trop tôt.
[75:30] Ce que tu vas faire, c'est qu'à terme, tu créeras
[75:32] une campagne à part, qui est une campagne de best-seller.
[75:34] Tu mettras tous tes produits best-seller dedans
[75:36] avec tes plus grosses marges, tes plus grosses rentabilités.
[75:38] Celle-là, tu iras la scaler. Et après,
[75:40] t'auras une campagne en support
[75:42] où tu garderas tes produits qui sont
[75:44] break-even ou... Peut-être que tu vois,
[75:46] sur ton catalogue, t'as un ROS moyen à 300
[75:48] et sur tes best-sellers, t'arrives à chercher du 500
[75:50] et à aller chercher de la rentabilité dessus.
[75:52] Ok, ça marche.
[75:54] Donc voilà.
[75:56] Mais là, pour le moment, à bout de 11 jours,
[75:58] tes break-even, améliore ton
[76:00] CRO, évite de
[76:02] trop toucher à ta campagne, c'est l'erreur numéro 1.
[76:04] Et derrière,
[76:06] récolte de la data gentiment jusqu'à passer
[76:08] sur une stratégie de maximiser la valeur de compte.
[76:10] Ça va bien se passer.
[76:12] Ok, c'est bon. Merci, Tristan.
[76:14] Pas de soucis.
[76:16] Alors, si t'as bien, on te
[76:18] donne la parole. Juste, je réponds
[76:20] à quelques questions, sinon...
[76:22] Il y a des questions qui m'ont sauté.
[76:30] La question n'a pas
[76:32] de magasin de référence comme Decathlon.
[76:34] Alors là, c'est minime.
[76:36] Il n'y a pas de concurrent en drop.
[76:38] Ça peut marcher ou pas sur une niche ?
[76:40] Oui, ça peut marcher.
[76:42] Ou max 1 ou 2, mais que le prod en question
[76:44] n'a pas de magasin de référence
[76:46] comme Decathlon.
[76:48] C'est un site qui est spécialisé
[76:50] dans les tapis de course, par exemple.
[76:52] Je crois que la deuxième partie,
[76:54] je la comprends très bien.
[76:56] Parce que Decathlon,
[76:58] c'est pas un site qui est spécialisé
[77:00] dans les tapis de course.
[77:02] C'est plutôt un généraliste dans le sport.
[77:04] Non, mais techniquement, il faut juste
[77:06] se poser la question, mais tout marche.
[77:08] Après, comme je vous dis, sur la recherche prod,
[77:10] déjà, il y a plusieurs choses.
[77:12] C'est qu'on pourrait vous faire des vidéos
[77:14] sur les recherches produits avec des méthodes différentes.
[77:16] Il faut vraiment partir
[77:18] d'appliquer une méthode.
[77:20] Une recherche prod, il faut vraiment arriver
[77:22] à ouvrir ses chakras dessus.
[77:26] C'est toujours la même chose.
[77:28] Moi, j'ai fait plusieurs formations.
[77:30] Le formateur montre une voie.
[77:32] Il y a tout le monde qui se lance dans le même truc.
[77:34] Mais même si on multiplie les méthodes
[77:36] de recherche produit,
[77:38] c'est vraiment plus le feeling à prendre.
[77:40] En fait, l'objectif des coachs,
[77:42] c'est aussi de ne pas vous envoyer
[77:44] sur des choses où on n'est pas trop sûr.
[77:46] Mais après, libre à vous,
[77:48] avec un petit peu d'expérience,
[77:50] d'aller tester.
[77:52] Même s'il n'y a pas de concurrent sur le produit,
[77:54] ça ne veut pas forcément dire que ça ne marche pas.
[77:56] Et ça peut être une bonne opportunité.
[77:58] Mais c'est vrai que pour quelqu'un qui débute ou quoi,
[78:00] lancez-vous plutôt sur quelque chose de facile,
[78:02] qui a déjà fait ses preuves,
[78:04] où il y a déjà une boutique qui fait du drop
[78:06] qui tourne depuis plusieurs mois.
[78:08] Ça valide le marché.
[78:10] Mais ensuite, libre à vous d'aller explorer
[78:12] d'autres horizons.
[78:14] Je vais essayer de faire un petit texte pour réponse.
[78:16] Comment je demande le texte ?
[78:18] J'ai un problème, j'ai eu 20 ajouts au panier, 3%.
[78:20] 10 étapes de paiement, 1,5 mais 0 ventre
[78:22] pour un produit vers les 300 euros.
[78:24] J'ai pourtant un max de trust au checkout.
[78:26] Et deux clients ont essayé de payer,
[78:28] mais le premier n'a pas marché via Shoei Payments.
[78:30] Je ne vais pas améliorer un truc ou de rien.
[78:32] Il manque trop de data, Alex.
[78:34] Combien tu as dépensé ?
[78:36] Quel est ton CPC ?
[78:38] Si tu as un CPC,
[78:40] alors je pourrais faire les calculs,
[78:42] tu as 20 ajouts au panier à 3%. Je ne vais pas me lancer là-dedans.
[78:44] Il manque trop d'éléments pour répondre, Alex.
[78:46] Mais tu peux me faire un gros message sur Skool
[78:48] avec toutes tes données.
[78:54] Tu penses quoi de One Click Print ?
[78:58] C'est un site pour la recherche de produits.
[79:00] Je ne sais pas si tu connais.
[79:02] Moi, je n'utilise pas ce genre d'outil.
[79:04] Après, je trouve que
[79:06] c'est des très bons outils.
[79:10] Franchement, c'est tout ce qui va être outil
[79:12] pour récolter de la data,
[79:14] des prods, etc.
[79:16] Si vous en avez besoin,
[79:18] ça peut être super.
[79:20] On peut détecter des opportunités.
[79:22] Moi, ce n'est pas le genre de site que je lance.
[79:24] Je n'utilise pas.
[79:30] Ton avis de mots est diverge.
[79:32] Tous les produits peuvent fonctionner
[79:34] en Search Ads.
[79:36] Est-ce que tous les produits
[79:38] peuvent fonctionner en Search Ads ?
[79:40] Oui.
[79:42] En Search Ads.
[79:44] En Campaign Search.
[79:46] Désolé, après une heure et quelques de live
[79:48] plus une démo, ça commence à...
[79:50] Non, pas forcément.
[79:56] C'est compliqué de répondre à ta question
[79:58] parce que techniquement,
[80:00] je pense que sur n'importe quelle niche,
[80:02] il y aurait moyen de trouver un angle
[80:04] qui soit rentable en Search.
[80:06] Typiquement, j'ai un client
[80:08] qui fait des ateliers cocktail sur Paris.
[80:10] Là, on a un gros problème
[80:12] avec son compte.
[80:14] C'est que l'acquisition directe,
[80:16] les clics sur ateliers cocktail Paris,
[80:18] ateliers cocktail sans alcool à Paris,
[80:20] formations mixologue Paris,
[80:22] etc.
[80:24] Ce sont des clics qui sont quasiment à 2 euros.
[80:26] Lui, il a un panier moyen
[80:28] qui est à 130 euros.
[80:30] Mais vu toutes les charges qu'il a,
[80:32] le local à Paris, etc.
[80:34] C'est hyper dur.
[80:36] Ce n'est même pas rentable.
[80:38] C'est tellement les clics sont chers.
[80:40] Ce n'est pas rentable d'aller chercher de l'acquisition directe.
[80:42] On peut aller faire des campagnes de Search
[80:44] sur que faire à Paris,
[80:46] activité de couple à Paris, etc.
[80:48] En élargissant l'entonnoir
[80:50] et avec une audience bien ciblée,
[80:52] on peut aller chercher de la rentabilité
[80:54] sur des CPC qui sont beaucoup moins chers.
[80:56] Tout ça pour vous dire que techniquement,
[80:58] je pense que sur n'importe quel marché,
[81:00] il y aurait un angle à trouver
[81:02] sur des requêtes que les internautes tapent.
[81:04] Mais on va dire qu'il y en a
[81:06] où c'est plus ou moins évident.
[81:08] Par contre, tu as vraiment des prods
[81:10] à achat de Barnum 4x4
[81:12] ou à achat de Barnum 6x9.
[81:14] Si vous voulez une niche, une très bonne niche,
[81:16] les Barnum, il faut trouver un fournisseur
[81:18] qui marche plutôt en location.
[81:20] Enfin, c'est plutôt des produits usés.
[81:22] Mais achat de Barnum, ça peut fonctionner.
[81:24] Là, par exemple, c'est un produit
[81:26] qui marcherait bien en Search.
[81:28] Moi, je dis qu'il faut toujours tester.
[81:30] Et après, il y a différentes typologies
[81:32] de campagnes.
[81:34] Mais il y aura toujours un mot-clé rentable.
[81:36] Il y aura toujours à trouver un mot-clé
[81:38] qui est rentable à pousser en Search.
[81:40] Je pense.
[81:42] C'est un petit peu fouillis, mais en même temps,
[81:44] c'est un petit peu dur de répondre à cette question.
[81:46] Mais je pense qu'il y a toujours un angle à prendre.
[81:48] Mais c'est vrai que ce sont des campagnes
[81:50] qui sont beaucoup plus dures à maîtriser.
[81:52] Parce que là où quelqu'un va taper
[81:54] « Jouer pour enfants »
[81:56] et nous, avec Tipeee Caban, on va apparaître
[81:58] si quelqu'un veut un Tipeee, il va cliquer.
[82:00] Mais s'il n'en veut pas, il ne va pas cliquer.
[82:02] Donc, on ne va pas perdre le clic.
[82:04] En Search, vu qu'il ne voit pas le produit,
[82:06] il ne voit pas le prix, etc.,
[82:08] la personne peut plus facilement cliquer,
[82:10] c'est pour trouver les bons mots-clés rentables
[82:12] et couper ceux qui ne sont pas rentables.
[82:14] J'ai fait une grosse parenthèse,
[82:16] mais j'espère que c'est plus clair.
[82:18] Si tu as l'air, tu peux enchaîner.
[82:22] J'avais juste deux questions.
[82:24] En fait, déjà,
[82:26] sur le shop que j'ai lancé,
[82:28] je pensais que tout était bon,
[82:30] tout était bon et tout.
[82:32] Sauf que j'avais suivi le process,
[82:34] attendu une semaine, deux semaines,
[82:36] le GMC s'est validé et tout.
[82:38] Mais au bout de trois, quatre jours,
[82:40] mes stocks
[82:42] se sont passés en refusé, tu vois.
[82:44] Donc, j'ai demandé au coach
[82:46] tout ça et il m'a dit que c'était
[82:48] parce qu'il y avait des liens cassés.
[82:50] Et en fait, dans le thème full stay,
[82:52] des fois, il te met des liens, des 400 cartes,
[82:54] bref, ça a mal accroché, du coup,
[82:56] il y avait des liens cassés.
[82:58] Et je voulais te demander si tu penses que c'est à cause de ça
[83:00] ou ça doit être autre chose.
[83:02] C'est quoi ? C'est une miss rep que tu as ?
[83:04] Ouais, c'est
[83:06] déclaration trompeuse et déceptive.
[83:08] Et il me demande de
[83:10] valider mon identité avant
[83:12] de redemander une analyse.
[83:14] Mais
[83:16] tu sais que ça, à mon avis, c'est
[83:18] juste... En fait, tu as une
[83:20] erreur de miss rep, mais à mon avis, c'est juste une validation
[83:22] de l'annonceur. Tu vas faire ta validation de l'annonceur
[83:24] et demain, tu repasses en valide.
[83:26] Sur Google Ads,
[83:28] j'ai fait la validation de l'annonceur.
[83:30] Moi, j'avais contacté
[83:32] le support,
[83:34] j'avais envoyé un petit mail et tout en haut à droite
[83:36] sur quelqu'un qui avait fait ça dans le school
[83:38] et ça a marché pour moi et
[83:40] même pas un jour, ils m'ont tout remis
[83:42] en validé.
[83:46] Vas-y, carré, je vais faire ça dès maintenant.
[83:48] Parce qu'il m'a dit quoi ? Parce qu'en fait, j'ai fait
[83:50] l'imbécile. Tu as vu,
[83:52] en bas de mes politiques,
[83:54] il y a le truc de contactez-nous, FAQ,
[83:56] suivi de commande. C'est ce que je mets en bas des politiques.
[83:58] Et comme un imbécile, je n'avais pas vu que
[84:00] en fait, ça ramenait sur des liens morts,
[84:02] en fait.
[84:04] Tu sais, ce que tu dis, c'est vraiment dans ton mail. Genre moi, j'avais dit, ouais,
[84:06] en gros, je m'étais trompé sur une politique
[84:08] de lien, politique de paiement. Je vais faire ça.
[84:10] Et tu dis, sinon, j'ai tout
[84:12] checké, tout est bon et tout, tu vas bien comme ça.
[84:14] Vas-y, carré, je vais faire ça parce que
[84:16] il n'y a rien de mal, tu vois.
[84:18] Juste quand tu cliques sur corriger
[84:20] dans ta miss-rate, en bas,
[84:22] tu n'as pas un bouton avec écrit validation
[84:24] de l'annonceur ? Si, il y a écrit
[84:26] je ne crois pas. En fait,
[84:28] il y a juste écrit
[84:30] valider votre identité avant de
[84:34] À mon avis, n'envoie pas
[84:36] le mail maintenant. À mon avis, si
[84:38] ta boutique, tu es sûr qu'elle est nickel, tu
[84:40] valides ton identité et
[84:42] dans quelques jours, tu vas voir, ça repasse au vert.
[84:44] Si ce n'est pas le cas, effectivement, comme tu as dit
[84:46] Samuel, tu peux aller contacter le chef.
[84:48] Ok, deuxième chose. Deuxième chose
[84:50] aussi, pareil. Sur là, c'était sur ma
[84:52] première boutique. Donc, ma première boutique
[84:54] pendant un mois,
[84:56] les produits étaient en cours d'examen.
[84:58] J'avais fait Google et Youtube. Pendant un mois,
[85:00] ils étaient en cours d'examen. Un moment, j'ai pété ma
[85:02] tête. J'ai dit, c'est un problème. On m'a dit,
[85:04] envoie un mail. J'ai envoyé un mail.
[85:06] Il y a un mec qui m'a répondu. Il m'a fait,
[85:08] vraiment désolé, pardon.
[85:10] On n'est pas vraiment désolé.
[85:12] Il m'a remis.
[85:14] Tout est passé au vert.
[85:16] Et là, je me suis
[85:18] réveillé lundi, dimanche.
[85:20] Excuse-moi, dimanche.
[85:22] Et j'ai vu que c'était en stock limité.
[85:24] Alors que
[85:26] tout était au vert pendant 2-3 jours.
[85:28] Mais tout est passé en stock
[85:30] limité ou une partie de ton catalogue est passé en stock limité ?
[85:32] Il y a peut-être sur
[85:34] sur 7 produits,
[85:36] il n'y en a que 1.
[85:38] Mais ça, ce n'est pas grave. Ça va repasser
[85:40] en normal.
[85:42] Sinon, tous les autres sont en limité.
[85:44] Mais techniquement, ça ne t'empêche
[85:46] pas de faire de l'add ?
[85:48] Je me suis dit, même pour le shop
[85:50] où je me suis fait refuser les produits,
[85:52] je te dis la vérité, hier,
[85:54] j'ai fait du search.
[85:56] Je me suis dit, vas-y, en vrai,
[85:58] je suis en train de me prendre la tête, je cherche la perfection.
[86:02] Je ne sais pas si tu sais bien ce que j'ai fait, mais
[86:04] j'ai fait une campagne search.
[86:06] Ça mériterait, il faudrait que je vois un peu
[86:08] ta situation.
[86:10] J'aimerais bien savoir si je peux prendre un appel avec toi
[86:12] et si pendant l'appel, on pourra,
[86:14] même si ça ne dure qu'une heure, je vais m'organiser
[86:16] avant l'appel pour pouvoir vraiment
[86:18] réfléchir sur chaque
[86:20] problématique, si c'est possible de faire ça avec toi.
[86:22] Tu as pris le school ou tu as pris
[86:24] uniquement, enfin, tu n'as pris que le school ou tu as pris l'accompagnement ?
[86:26] Et tout au moins, les 3 balles.
[86:28] Je n'ai pas entendu.
[86:30] J'ai tout pris, j'ai tout pris.
[86:32] Ok, parfait, tu peux
[86:34] envoie un message sur le school et
[86:36] je t'envoie mon renne.
[86:38] Ok, parfait, vas-y,
[86:40] je t'envoie un message tout de suite.
[86:42] Allez, parfait.
[86:44] Comme ça, on check et tu pourras me répondre à tes questions.
[86:46] Désolé les gars, si j'ai été long.
[86:48] Désolé les gars, merci beaucoup.
[86:50] T'inquiète, il n'y a pas de soucis, c'est l'objectif des lives.
[86:52] Donc, pas de problème, t'inquiète.
[86:54] J'espère que j'ai pu répondre à un
[86:56] max de tes questions et on verra pour
[86:58] le reste. Mais à mon avis, fais ta validation de l'annonceur.
[87:00] Et d'ailleurs, Axel, je pense à toi.
[87:02] Contacte le support. Mais je crois que je te l'avais déjà dit, non ?
[87:04] De contacter le support.
[87:06] Non, tu ne l'avais pas encore dit.
[87:08] Ok, parfait.
[87:10] Fais ça, contacte le support
[87:12] directement, disons que ça fait plusieurs jours que tes produits sont
[87:14] en attente, sont en examen
[87:16] et que tu ne comprends pas et que
[87:18] tu as tout bien fait.
[87:20] La demande, elle doit te générer un petit mail.
[87:22] Un dernier truc, les gars, et après
[87:24] je vous promets, je me mettais. Juste, est-ce qu'il y a un groupe WhatsApp
[87:26] avec les gens de,
[87:28] comment dire, avec les personnes du school,
[87:30] tout ça, genre, tu sais, un petit groupe où ça
[87:32] bosse ensemble, où ça s'appelle,
[87:34] des trucs de, je ne sais pas moi, un truc
[87:36] pour se soutenir, un petit groupe
[87:38] où est-ce qu'il y a ça ou il n'y a pas, les gars ?
[87:40] Ça peut être une
[87:42] bonne idée à rajouter dans le school,
[87:44] groupe de travail.
[87:46] Je serais chaud, tu vois, faire des petites séances de travail.
[87:48] On est, tu vois, sur Zoom,
[87:50] on bosse de minuit jusqu'à deux heures,
[87:52] les mecs qui se couchent tard, tu vois,
[87:54] faire un petit truc sympa où on peut
[87:56] se parler tous les jours. Et puis même, il y en a qui n'ont pas forcément
[87:58] tout l'accompagnement. Sinon, on a
[88:00] des idées, on a des trucs, on peut leur... Enfin, tu vois,
[88:02] un truc comme ça, quoi.
[88:04] Eh bien, écoute, c'est une très bonne idée. Je vais
[88:06] filer l'idée.
[88:08] De créer dans le school, effectivement,
[88:10] un petit onglet où on peut se partager un lien
[88:12] Zoom, un lien Meet pour faire des sessions
[88:14] de travail à plusieurs. Exactement, fort.
[88:16] Eh bien, merci, les gars. Impecc.
[88:18] Eh bien, merci à toi. Samuel, tu as une question ?
[88:20] Oui, oui.
[88:22] Rapidement, dans le school, ils disent
[88:24] que... Enfin, ils règlent le CPC sur
[88:26] l'engin la plus haut, l'engin la plus basse divisé par deux,
[88:28] en gros, une moyenne. Et toi, tu
[88:30] conseilles ça ou tu adaptes en fonction du
[88:32] CPC ? Parce que sur deux mêmes boutiques,
[88:34] je suis sur un CPC.
[88:36] Donc, je ne sais pas trop comment le régler, mais ils disent, en gros,
[88:38] si il est haut, vous mettez 0,69
[88:40] max, 0,69 max.
[88:42] Mais même ça, en vrai, ce n'est pas...
[88:44] Ça ne suffit pas pour être à la moyenne. Donc, je ne sais pas ce que tu recommandes, toi.
[88:46] OK. Moi, ce que
[88:48] je recommande, c'est dans un premier temps, de se
[88:50] mettre entre... Enfin, la moyenne entre la fourchette haute et la
[88:52] fourchette basse. Moi, parfois, je fais le choix.
[88:54] Si je veux un peu plus diffuser et gagner
[88:56] du temps, enfin, ou tester,
[88:58] je me mets souvent un tout petit peu au-dessus
[89:00] de la moyenne.
[89:02] Mais sinon, c'est une très bonne base pour commencer.
[89:04] Vraiment, c'est... Je fais la même chose
[89:06] pour commencer. OK. Et après,
[89:08] pour Stavia, il y a
[89:10] C-E-O-I... C-E-O-I, j'y
[89:12] suis arrivé, est une petite
[89:14] option, c'est une app Shopify, pour détecter les
[89:16] 404. Genre, moi, je n'en avais pas un qui a été créé
[89:18] de... Je ne sais pas pourquoi, et j'ai juste fait
[89:20] des redirigations après sur la page d'accueil, et ça t'évite d'avoir
[89:22] des 404 un peu chelou. Voilà.
[89:24] Mais d'ailleurs, Stavia, si on est en
[89:26] call, je te ferais un
[89:28] Scrapping Screaming
[89:30] Frog sur ta boutique.
[89:32] Je suis tôt. D'ailleurs, il y a écrit valider
[89:34] l'identité. Il y a bien un truc où, genre...
[89:36] Je te dis... Avant de
[89:38] te demander un examen... Fais valider
[89:40] l'identité. Tu valides ton identité, tu demandes un
[89:42] examen. Je suis sûr que demain ou dans les prochains jours,
[89:44] c'est validé. OK, boss.
[89:46] Merci. Merci, boss.
[89:48] Non, tu pourras crier...
[89:50] Enfin, je ne m'avance pas, mais
[89:52] tu pourrais dire que je t'ai dit une connerie, mais
[89:54] de ce que tu me dis, je pense que
[89:56] c'est juste une validation de l'annonceur que tu t'es pris.
[89:58] Mais c'est bizarre. Pourquoi ils demandent une...
[90:00] Ils disent déclaration trop prosédéceptive.
[90:02] On dirait que j'ai scammé
[90:04] Macron. Non, non,
[90:06] mais c'est normal. Pour une validation de l'annonceur, c'est juste une erreur.
[90:08] Tu valides et normalement, ça devrait être bon.
[90:10] Vu comment tu me le décris,
[90:12] je pense que c'est ça.
[90:14] Voilà.
[90:16] Et Alex, je t'écoute.
[90:18] Yes.
[90:20] Moi, j'avais une question. Du coup, là,
[90:22] ça fait deux semaines que j'ai une
[90:24] shopping qui tourne... Je ne sais pas
[90:26] si tu te souviens de mon site. Je te l'avais envoyé sur School.
[90:28] Et je n'ai toujours pas fait de vente,
[90:30] etc. Mais je voulais savoir
[90:32] via les stats et tout
[90:34] si ça pue ou
[90:36] si je laisse encore tourner, etc.
[90:38] Donc, j'ai les stats devant. Si tu veux,
[90:40] je peux t'énumérer un peu
[90:42] brièvement. C'est Axel X sur School ?
[90:44] Ouais.
[90:46] Attends, pardon.
[90:48] Je vérifie. Je crois.
[90:50] Qu'est-ce que j'ai mis ?
[90:52] Qu'est-ce que j'ai mis ?
[90:54] Qu'est-ce que j'ai mis ?
[90:56] Non, Alex Muriel.
[90:58] Alex Muriel, ok.
[91:02] Ah, mais oui, on en avait parlé la dernière fois.
[91:04] Ouais, ouais.
[91:06] Vas-y. Mais je crois que tu m'expliques. D'ailleurs, tu as dit que tu allais
[91:08] m'expliquer si tu étais qui les clients.
[91:10] Ah, ouais.
[91:12] Mais si j'explique, après, je...
[91:14] Oui, mais tu me le diras. Toi, je te l'ai écrit dans School.
[91:16] Tu me dis si c'est ça,
[91:18] ça va me faire marrer.
[91:26] C'est ça ?
[91:28] En partie, ouais.
[91:30] En fait, c'est vraiment les deux extrêmes.
[91:32] C'est un malade.
[91:34] Ok.
[91:36] Putain, tu dois avoir un SR et cocasse.
[91:40] Mais je te dis, en soit...
[91:44] Putain, mais lance aux US, hein.
[91:46] Bah, ouais.
[91:48] Je te l'ai déjà dit la dernière fois, mais lance aux US.
[91:50] Et tu as dépensé ta spend combien,
[91:52] en total ? Bah, du coup,
[91:54] je crois que je suis vers
[91:56] les 162 spend.
[91:58] CPC à 30 centimes,
[92:00] donc j'ai fait, genre, pas loin de 600
[92:02] clics. J'ai eu...
[92:04] 20 à jouer au panier,
[92:06] 10 étapes de paiement, mais
[92:08] il y a 0 vente, mais
[92:10] j'ai vu, il y a 2 personnes
[92:12] qui ont essayé de payer, mais ça flop.
[92:14] Donc, bah, avec ça, j'aurais
[92:16] ROES de 3.
[92:18] Donc, un peu dommage.
[92:20] Mais, ouais.
[92:22] Déjà, mets bien en place tes
[92:24] flows de suivi.
[92:28] Attends. Mets bien en place tes flows.
[92:30] Après, il faudrait tester, il faudrait faire une commande de test.
[92:32] Mais je pense qu'il n'y a pas de problème. Bah,
[92:34] je l'ai faite, déjà, c'est pour ça.
[92:36] Donc, euh...
[92:38] J'ai vu, il y a un mec
[92:40] qui a essayé de payer avec Klarna,
[92:42] ça n'a pas marché.
[92:44] Et un autre... Mais, moi, Klarna,
[92:46] je ne l'ai pas activé.
[92:48] Ouais, bah, là, je l'ai désactivé.
[92:50] Non, laisse-le activer. Si ça ne marche pas, Klarna,
[92:52] c'est normal, c'est juste qu'en fait,
[92:54] le gars n'est pas éligible
[92:56] pour un prêt. Ah, ok.
[92:58] Ça ne veut pas dire que ça n'a pas fonctionné,
[93:00] que c'est un bug de Klarna, c'est... Mais quoi ?
[93:02] Il connait combien il a sur son compte
[93:04] en banque et...
[93:06] Ah, bah, oui. T'imagines, sinon, ce serait trop simple.
[93:08] Ouais, ouais. Tu te rends compte à zéro,
[93:10] sans existence, tu fais un truc Klarna
[93:12] et tu disparais avec des faces d'information.
[93:14] T'inquiète pas qu'ils sont doués.
[93:16] Et Klarna, toi, tu déconseilles, Tristan ?
[93:18] Non, au contraire, je conseille.
[93:20] Mais, en fait, c'est juste que...
[93:24] Il a désactivé parce que, vu qu'il
[93:26] a vu que la vente, elle n'avait pas passé avec Klarna,
[93:28] il l'a désactivé pour ça. Mais, moi, j'ai dit non.
[93:30] Klarna, en fait, c'est pas un problème
[93:32] que Klarna ne marche pas, c'est un problème que
[93:34] le mec ne devait pas être solvable.
[93:36] Du moins, il...
[93:38] Non, c'est juste que
[93:40] les mouvements sur son compte en bancaire
[93:42] ne permettent pas à Klarna d'être sûr
[93:44] qu'ils seront payés...
[93:46] Bon, bref, il y a plusieurs raisons, mais bon...
[93:50] En tout cas, c'est une décision de Klarna,
[93:52] ils ont simplement pas accepté. Non, ça m'a l'air d'être fonctionnel
[93:54] sur ton site.
[93:56] Est-ce que t'as
[93:58] eu des demandes, t'as eu des contacts par...
[94:00] par mail ou pas ?
[94:02] T'as eu...
[94:04] Euh, non, rien de spécial.
[94:06] Personne qui m'a...
[94:08] Essaye d'envoyer un mail
[94:10] à contact
[94:12] ton nom de domaine.
[94:14] Putain, j'ai fait une fin d'année.
[94:16] Envoie un mail à ton nom
[94:18] de domaine et regarde si ça marche.
[94:20] Ouais, ouais.
[94:22] Ok, je vais check ça.
[94:24] Mais bon, si tu veux mon avis, moi,
[94:26] à ta place, mais bon, pareil,
[94:28] ça dépend vraiment de ta capacité,
[94:30] et...
[94:32] et ce que tu veux faire,
[94:34] mais...
[94:36] Moi, je dépenserai deux fois le prix de mon
[94:38] produit avant de cléter.
[94:40] En gros, moi, je dépenserai 500 balles
[94:42] avant de cléter, s'il n'y a pas de vente.
[94:44] Ah ouais, carrément, ok.
[94:46] Ok, ça va.
[94:48] À la prochaine, alors.
[94:50] Bah, écoute,
[94:52] pas de soucis, mais je te redis,
[94:54] t'es vraiment sur un truc très particulier, quand même.
[94:56] En tout cas, je suis sûr que
[94:58] je vais se... C'est un excellent prod.
[95:00] Ouais, mais j'ai vu, il y a quand même
[95:02] la concurrence, du coup, c'est rien à voir, tu vois.
[95:04] Il y a des marques vachement
[95:06] implantées, Trustpilot
[95:08] a plus de 10 000...
[95:10] 10 000 avis, c'est...
[95:12] c'est un autre...
[95:14] Après, euh...
[95:16] Parce que si on est sur la typologie de client
[95:18] que je t'ai écrit, ils ont...
[95:20] Enfin...
[95:22] Non, mais je pense que
[95:24] ça représente qu'une part, tu vois.
[95:26] Je sais pas.
[95:28] Franchement, j'essaie pas.
[95:30] Les noms liquides !
[95:36] Ok. Ouais, ça marche.
[95:38] Bon, bah, ok. Ça marche.
[95:40] Merci. Pas de soucis.
[95:42] Et, euh...
[95:44] Écoutez, ça va être la fin du
[95:46] live, juste avant de terminer.
[95:48] Dernière petite chose, puisque, bah,
[95:50] on se rappelle, au début, il y avait une petite
[95:52] démo sur le Gateway, et
[95:54] hop, hop, hop...
[95:56] Hum...
[95:58] ...
[96:00] Je vais juste fermer ça.
[96:02] Nickel.
[96:04] On va pouvoir fermer Analytics aussi.
[96:06] Et donc, voilà, j'ai rafraîchi
[96:08] la page.
[96:10] Et donc, là, ça me dit que tout est good.
[96:12] Donc, voilà,
[96:14] le changement de serveur DNS
[96:16] a bien marché. Donc, il faut toujours attendre,
[96:18] en fait, le temps que ça se propage
[96:20] et que ça se diffuse. Donc, bah, on va pouvoir
[96:22] ensemble reprendre. Donc, ici,
[96:24] maintenant, si je fais
[96:26] connexion, que je fais continuer,
[96:28] Cloudflare, continuer,
[96:30] la valise Google, se connecter à Cloudflare.
[96:36] Impeccable.
[96:40] Autoriser. Comme tout à l'heure, la même
[96:42] démarche, sauf que cette fois-ci, normalement...
[96:44] Alors, c'est connecté.
[96:46] Je peux faire terminer la configuration.
[96:48] Et la configuration est maintenant
[96:50] terminée. Juste, bah, il y a
[96:52] le sous-domaine
[96:54] accounts.tpkban, puisque
[96:56] il y a le sous-domaine pour
[96:58] la connexion de compte. Mais bon, ça ne sert à rien
[97:00] de le connecter, puisque il n'y a rien à traquer
[97:02] sur accounts. Donc, je peux faire OK.
[97:04] Et donc, là, voilà.
[97:06] Le...
[97:08] Tout est bien configuré.
[97:10] Bon, il y aurait possibilité d'aller un petit peu
[97:12] plus loin avec le domaine
[97:14] accounts. Mais, vu qu'il n'y a
[97:16] rien à traquer dessus, je ne vais pas aller plus loin.
[97:18] J'espère qu'en tout cas, cette démo, cette petite
[97:20] solution vous a plu, en attendant que
[97:22] des modules plus complets arrivent
[97:24] dans la formation sur ces sujets
[97:26] de tracking. Donc, il y a vraiment...
[97:28] complexe en ce moment, mais qui est
[97:30] le nerf de la guerre. Mais en tout cas, ça, ça va
[97:32] grandement améliorer le problème.
[97:34] Et surtout, c'est gratuit. Il n'y a pas
[97:36] besoin d'un abonnement en plus. Et ça, c'est cool.
[97:38] Bah, voilà. J'espère que ça vous aura plu.
[97:40] Et je vous souhaite une excellente
[97:42] soirée. Et à la prochaine.
[97:44] Merci à tous.
[97:46] Merci.
[97:48] Ciao.
[97:50] Eh bien, ciao tout le monde.
[97:58] Sous-titrage ST' 501