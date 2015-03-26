# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create a user
anon_user = User.create!(name: 'Anonymous', login:'Anon', email: 'anon@test.com', password: '12345678')
admin_user = User.create!(name: 'Admin', login:'admin', email: 'admin@test.com', password:'12345678', admin: true)

# Create some categories and docs
category = Category.create(name: 'First Steps', rank: 1)
category.docs.create(title: "Getting Started", body: '# Et minus equi velamina terras

## Artes aere

Lorem markdownum pessima leves; monstri non nivibus futuri urbes, in miseram
vultus. Est alite. Neque comae dei antro qui ex, inmissa inflataque huic sua,
curru.

Infirmos turea quod animoque est cuspidis! Inpositaque satis Rhodopen et detur,
curalium matre obice modo altera deos, lingua.

1. Animi nullisque nam
2. Sit invictus magnoque proles
3. Imperat avita hastam

Curvamine **similis locum** dies orbis, repulsus genibus corpora sit solvit
passim [licet](http://seenly.com/), ortus. Condit fueram Cyllenius requirit ad
[sinus dissiluit](http://jaspervdj.be/) luctus magnis: capillos colunt.

## Opus valle coloribus calculus aegram quam tendens

*Arboreo vultum*. Et solet quinque formosior rapinae quia, toto arte tenebant
quam hic? Medicamine cinis.

1. Est sub illa nactus Scirone
2. Valido sententia
3. Luctus membraque Tartara capillos me spumam rerum
4. Et umbra

**Retracto** spatio! Mihi [ignavus tela](http://www.lipsum.com/): rostro sedes,
nunc semel digitos. [Ore huic sim](http://www.metafilter.com/) erat montibus,
consumpta victricia mittit favorem inpleverunt mora, manente, est in alteraque
dixere.

> Aetas eiectat nostra fuerant et herbas Oceano et et tectis spiritus texerat,
> gerebat siccaeque et quod ceras de solum. Simulacra nec quorum confusura ora
> tandem auras, nervis fida nec induruit quae, virorum rasa.

Honore **caede gramine oraque** praesagia, in mero lacrimas mutato inprudens
brevis crura, in caelum cessasse biceps vectabantur color? Me [verebor
vox](http://omgcatsinspace.tumblr.com/) femina in *crudelis* pubis *caelo
dumque* morsus.')
category.docs.create(title: "Setting Up", body: '# Sacer quae redis

## Mittuntque fixum

Lorem markdownum equos Erysicthonis dixit fratris: portis virgo attenuarat adit
maiores spreta toro? Retro labefactaque sacra animi manantem circumtulit perque:
agros rima digna, sacri regemque. In nusquam res **probat** ut tulit Panomphaeo
bracchia *in* oblita iuvenis caducifer celer.

    gigabit.smtp_minisite_microcomputer += ios;
    file_load.pimWysiwygData.formatRup(wizard_operating_quicktime(
            compressionComputing, vfat + kibibyte_white_matrix, direct + 19),
            infringement_tcp_macro.windows.gigaflops_dma(session, hsf * 2));
    fileDhcpOlap.restore_dfs(smmRight, social_type);
    if (tag + raster < 4 + analogWildcardKey * smtp + bookmarkClientDlc) {
        usbLeaderboard = cell;
    }
    ssl.ddrSearchRaw = primaryLedType.richMmsProcess(1 + direct, edi, ribbon) +
            sdk;

## Vocant acta aequaverit placet auras poeniceas fallaci

Et nec deum, sua canna, devotaque deus prodidit ambiguum mecum dolor: Medea
primusque imminet rupisque. De sedet Rhanisque quod secretasque deam te quem
omnes mater est inbutum sacra ad proles, dum. Ignota cur cruor cucurri; magni,
scissaeque *cruor attollens* pariter paratu resisti inhaesit alba. Pulmonibus
sic turbasti cuspide saxum, est utque petunt agitasse vocis emicuit, rettulit,
corpore. Diu est solita colebat Iuppiter mihi invita undarum et tantum ignota
sonos amat decent, Iuppiter et.

Poteram sequentis tulit, ad sitim thalamique nullum responderat [victor
promittere](http://stoneship.org/) nata. Donec et luctus parte cumque templorum
si animos tegis nec crura virgineas iactanti litoris subdit scelerataque fixis!
Fretumque legeret.

## Commisit si mearum

Parsque quercum a de sic subito sitim corpore? Suae illa transire optata:
*nostro* placidum dentibus circa et mentita erat una et spolioque Fames. Suas
fit suae intrat nocet hosti putat ignes; invenerit promissa: dilapsa sibi
lyncum. Mollirique nostris sine. Phoebus eum arma vir signa agitur [et ille
quisque](http://html9responsiveboilerstrapjs.com/) artes, lumina lacrimasque
insidior pulsis uti solum fert conscelero.

Tota dat, par pater mota intacta, auxiliaris turbamve; agnoscit terque commota
cum, non. Atque pulchros; currus retinet mediaque tauri Lethes recentia peremi.

## Mente in invida requiem

Valuere cupiuntque eget: ut **humum pinnis**, Helops regna, Ino. Veteres oculos
et via: tu fortes! Delubra cernere post seri annis, cur innoxia *milibus*
sustinet venerat.

Vestigia vultus iuncturas Astyanax Lucinam in postes scilicet potest funera, et,
ait arbitrium situs et *illic*: vultus. Suos corpore vitta flagrant, coercuit
nemorum oblectamina **longe**: saevit vix. Imo animae herba properent iactantem
capillis stabat domos moresque gemitumque sospes flavescit animam sequitur
tumulo Nessus. Quoque et ait altera Phoebo nostro, huc venti suis Cadmi artus
Hecabe sollertior. **Locum longaeque Thracia** primumque resupinus fratres
*corpus aeacidae sparsisque* saepe.')

#Create some forums and posts
f = Forum.create(name: "Getting Started", description: "If you have questions about where to start, post them here!")
t = f.topics.create(name: "Can't get logged in", user_id: anon_user.id)
t.posts.create(user_id: anon_user.id, body: "A bunch of interesting stuff usually goes here!!!!")
t.posts.create(user_id: admin_user.id, body: "This is where the brilliant and witty reply by someone really smart goes!")
#t.tag
t = f.topics.create(name: "The interface", user_id: anon_user.id)
t.posts.create(user_id: anon_user.id, body: "A bunch of interesting stuff usually goes here!!!!")
t.posts.create(user_id: admin_user.id, body: "This is where the brilliant and witty reply by someone really smart goes!")

#t.tag
