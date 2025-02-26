#!/usr/bin/python3
import pandas as pd
from scipy.stats import mannwhitneyu
df = pd.read_excel("genefamily.xlsx", sheet_name="change", header=0)
Parasitoida = ["Belonocnema_kinseyi<11>", "Leptopilina_heterotoma<12>", "Leptopilina_boulardi<13>", "Telenomus_remus<14>", "Copidosoma_floridanum<15>", "Eretmocerus_hayati<16>", "Chouioia_cunea<17>", "Trichogramma_pretiosum<18>", "Theocolax_elegans<19>", "Ceratosolen_solmsi<20>", "Eupristina_verticillata<21>", "Anastatus_fulloi<22>", "Anastatus_japonicus<23>", "Pachycrepodieus_vindemmiae<24>", "Anisopteromalus_calandrae<25>", "Nasonia_vitripennis<26>", "Trichomalopsis_sarcophagae<27>", "Pteromalus_qinghaiensis<28>", "Pteromalus_venustus<29>", "Pteromalus_puparum<30>", "Ophion_luteus<31>", "Venturia_canescens<32>", "Buathra_laborator<33>", "Diadromus_collaris<34>", "Ichneumon_xanthorius<35>", "Amblyteles_armatorius<36>", "Aphidius_gifuensis<37>",
               "Binodoxys_communis<38>", "Habrobracon_hebetor<39>", "Diachasma_alloeum<40>", "Fopius_arisanus<41>", "Macrocentrus_cingulum<42>", "Microctonus_aethiopoides<43>", "Microctonus_hyperodae<44>", "Chelonus_insularis<45>", "Microplitis_demolitor<46>", "Microplitis_mediator<47>", "Apanteles_cypris<48>", "Cotesia_glomerata<49>", "Cotesia_chilonis<50>", "Cotesia_sesamiae<51>", "<143>", "<144>", "<145>", "<146>", "<147>", "<148>", "<149>", "<150>", "<151>", "<152>", "<153>", "<154>", "<155>", "<156>", "<157>", "<158>", "<159>", "<160>", "<161>", "<162>", "<163>", "<164>", "<165>", "<166>", "<167>", "<168>", "<169>", "<170>", "<171>", "<172>", "<173>", "<174>", "<175>", "<176>", "<177>", "<178>", "<179>", "<180>", "<181>", "<182>"]

stinger = ["Gonatopus_flavifemur<52>", "Ancistrocerus_nigricornis<53>", "Mischocyttarus_mexicanus<54>", "Polistes_dominula<55>", "Polistes_canadensis<56>", "Polistes_fuscatus<57>", "Vespula_germanica<58>", "Vespula_vulgaris<59>", "Vespula_pensylvanica<60>", "Dolichovespula_media<61>", "Dolichovespula_sylvestris<62>", "Dolichovespula_saxonica<63>", "Vespa_velutina<64>", "Vespa_mandarinia<65>", "Vespa_crabro<66>", "Anoplius_nigerrimus<67>", "Tiphia_femorata<68>", "Dinoponera_quadriceps<69>", "Harpegnathos_saltator<70>", "Odontomachus_brunneus<71>", "Eciton_burchellii<72>", "Ooceraea_biroi<73>", "Linepithema_humile<74>", "Pseudomyrmex_gracilis<75>", "Nylanderia_fulva<76>", "Camponotus_floridanus<77>", "Formica_exsecta<78>", "Cataglyphis_hispanica<79>", "Pogonomyrmex_barbatus<80>", "Vollenhovia_emeryi<81>", "Temnothorax_longispinosus<82>", "Temnothorax_curvispinosus<83>", "Solenopsis_invicta<84>", "Monomorium_pharaonis<85>", "Wasmannia_auropunctata<86>", "Cyphomyrmex_costatus<87>", "Trachymyrmex_zeteki<88>", "Trachymyrmex_cornetzi<89>", "Trachymyrmex_septentrionalis<90>", "Atta_colombica<91>", "Acromyrmex_echinatior<92>", "Acromyrmex_insinuator<93>", "Pseudoatta_argentina<94>", "Acromyrmex_charruanus<95>", "Ampulex_compressa<96>", "Nysson_spinosus<97>", "Ectemnius_continuus<98>", "Pemphredon_lugubris<99>", "Cerceris_rybyensis<100>", "Mimumesa_dahlbomi<101>", "Macropis_europaea<102>", "Andrena_dorsata<103>",
           "Andrena_fulva<104>", "Andrena_haemorrhoa<105>", "Colletes_gigas<106>", "Hylaeus_volcanicus<107>", "Hylaeus_anthracinus<108>", "Dufourea_novaeangliae<109>", "Nomia_melanderi<110>", "Megalopta_genalis<111>", "Sphecodes_monilicornis<112>", "Lasioglossum_morio<113>", "Seladonia_tumulorum<114>", "Anthidium_xuezhongi<115>", "Stelis_phaeoptera<116>", "Megachile_rotundata<117>", "Osmia_bicornis<118>", "Osmia_lignaria<119>", "Holcopasites_calliopsidis<120>", "Habropoda_laboriosa<121>", "Ceratina_calcarata<122>", "Eufriesea_mexicana<123>", "Apis_florea<124>", "Apis_mellifera<125>", "Apis_cerana<126>", "Melipona_quadrifasciata<127>", "Frieseomelitta_varia<128>", "Bombus_pyrosoma<129>", "Bombus_impatiens<130>", "Bombus_terrestris<131>", "<183>", "<184>", "<185>", "<186>", "<187>", "<188>", "<189>", "<190>", "<191>", "<192>", "<193>", "<194>", "<195>", "<196>", "<197>", "<198>", "<199>", "<200>", "<201>", "<202>", "<203>", "<204>", "<205>", "<206>", "<207>", "<208>", "<209>", "<210>", "<211>", "<212>", "<213>", "<214>", "<215>", "<216>", "<217>", "<218>", "<219>", "<220>", "<221>", "<222>", "<223>", "<224>", "<225>", "<226>", "<227>", "<228>", "<229>", "<230>", "<231>", "<232>", "<233>", "<234>", "<235>", "<236>", "<237>", "<238>", "<239>", "<240>", "<241>", "<242>", "<243>", "<244>", "<245>", "<246>", "<247>", "<248>", "<249>", "<250>", "<251>", "<252>", "<253>", "<254>", "<255>", "<256>", "<257>", "<258>", "<259>", "<260>", "<261>"]
adict = {}
# Specifies the file that contains the divergence time.
df1 = pd.read_excel("data.xlsx", sheet_name="time", header=0)
for index, row in df1.iterrows():
    sep = row["<node>"]
    adict[sep] = row["branch.length"]

w = open("OG.variance.txt", "w+")
w.write(f"FamilyID")
w.write("\n")
for index, row in df.iterrows():
    values = []
    Parasitoidavalues = []
    stingervalues = []
    for i in Parasitoida:
        Parasitoidavariance = abs(row[i])
        Parasitoidalength = float(adict[i])
        # The number of gene family expansions or contractions divided by the divergence time
        Parasitoidavalue = float(Parasitoidavariance/Parasitoidalength)
        Parasitoidavalues.append(Parasitoidavalue)
    for i in stinger:
        stingervariance = abs(row[i])
        stingerlength = float(adict[i])
        stingervalue = float(stingervariance/stingerlength)
        stingervalues.append(stingervalue)
    # Identify gene families with significantly higher rates of gene gain and loss in the Parasitoida compared to Aculeata, and vice versa.
    # All Mann-Whitney U tests in manuscript are calculated as follows. Note that alternative should be changed to two-sided in two-tailed tests.
    Parasitoida2stingerU1, Parasitoida2stingerP = mannwhitneyu(
        Parasitoidavalues, stingervalues, alternative='greater')
    stinger2ParasitoidaU1, stinger2ParasitoidaP = mannwhitneyu(
        stingervalues, Parasitoidavalues, alternative='greater')
    w.write("%s\t%.4f\t%.4f\t%.4f\t%.4f\n" % (
        row["FamilyID"], Parasitoida2stingerU1, Parasitoida2stingerP, stinger2ParasitoidaU1, stinger2ParasitoidaP))
w.close()
