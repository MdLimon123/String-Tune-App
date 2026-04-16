import React, { useState, useEffect } from "react";
class ErrorBoundary extends React.Component {
  constructor(props) { super(props); this.state = { error: null }; }
  static getDerivedStateFromError(e) { return { error: e }; }
  render() {
    if (this.state.error) {
      return (
        <div style={{ padding: 20, background: "#1a0000", color: "#ff6b6b", fontFamily: "monospace", fontSize: 12, whiteSpace: "pre-wrap" }}>
          <div style={{ fontWeight: 900, marginBottom: 8 }}>CRASH:</div>
          <div>{String(this.state.error)}</div>
          <div style={{ marginTop: 8, color: "#666" }}>{this.state.error && this.state.error.stack}</div>
        </div>
      );
    }
    return this.props.children;
  }
}



// ─── ARTIST DATA ───────────────────────────────────────────────────────────────
const ARTIST_TUNINGS = [
  // ── E Standard ──────────────────────────────────────────────────────────────
  { name: "Tony Iommi", band: "Black Sabbath", era: "Black Sabbath / Paranoid / TE / NSD", tuning: "E", gauges: [".008",".008",".011",".018",".024",".032"], scaleLength: 24.75, notes: "Early Sabbath era. Detuned a half step and used very light gauges to compensate for missing fingertips.", verified: true, genre: "Doom" },
  { name: "Buzz Osborne", band: "Melvins", era: "E Standard", tuning: "E", gauges: [".010",".013",".017",".026w",".036w",".052w"], scaleLength: 25.5, notes: "10–52 set. Also used in Drop D.", verified: true, genre: "Sludge" },
  { name: "Victor Griffin", band: "Pentagram", era: "E Standard", tuning: "E", gauges: [".009",".011",".016",".024w",".032w",".046w"], scaleLength: 24.75, notes: "9–46. Also played Eb on some recordings.", verified: true, genre: "Doom" },

  // ── Eb Standard ─────────────────────────────────────────────────────────────
  { name: "Dylan Carlson", band: "Earth", era: "Eb Standard", tuning: "Eb", gauges: [".010",".013",".017",".026w",".036w",".046w"], scaleLength: 25.5, notes: "Standard 10–46. Earth's signature slow, droning Eb tone.", verified: true, genre: "Drone" },
  { name: "Phil Caivano", band: "Monster Magnet", era: "Eb Standard", tuning: "Eb", gauges: [".011",".014",".018",".028w",".038w",".048w"], scaleLength: 25.5, notes: "11–48 in Eb. Also used 13–60 in C Standard.", verified: true, genre: "Stoner" },
  { name: "Victor Griffin", band: "Pentagram", era: "Eb Standard", tuning: "Eb", gauges: [".009",".011",".016",".024w",".032w",".046w"], scaleLength: 24.75, notes: "9–46. Used for several Pentagram recordings.", verified: true, genre: "Doom" },

  // ── D Standard ──────────────────────────────────────────────────────────────
  { name: "Pepper Keenan", band: "Corrosion of Conformity", era: "D Standard", tuning: "D", gauges: [".011",".014",".018",".028w",".038w",".052w"], scaleLength: 25.5, notes: "11–52 in D Standard. Southern groove and sludge.", verified: true, genre: "Sludge" },
  { name: "Woody Weatherman", band: "Corrosion of Conformity", era: "D Standard", tuning: "D", gauges: [".011",".014",".018",".028w",".038w",".052w"], scaleLength: 25.5, notes: "11–52. Matches Keenan's setup for tight rhythm work.", verified: true, genre: "Sludge" },
  { name: "Bob Balch", band: "Fu Manchu", era: "D Standard", tuning: "D", gauges: [".011",".014",".018",".028w",".038w",".048w"], scaleLength: 25.5, notes: "11–48 in D Standard. Fuzz-heavy stoner tone.", verified: true, genre: "Stoner" },
  { name: "Dave Shepherd", band: "Weedeater", era: "D Standard", tuning: "D", gauges: [".011",".014",".018",".028w",".038w",".049w"], scaleLength: 25.5, notes: "11–49. Weedeater's filthy swamp sludge in D.", verified: true, genre: "Sludge" },

  // ── C# Standard ─────────────────────────────────────────────────────────────
  { name: "Tony Iommi", band: "Black Sabbath", era: "MOR / Vol.4 / SBS / Sabotage", tuning: "Db", gauges: [".009",".010",".012",".020",".032w",".042w"], scaleLength: 24.75, notes: "Dropped to C# to reduce tension after losing fingertips. Custom light set on 24.75″ SG.", verified: true, genre: "Doom" },
  { name: "Pepper Keenan", band: "Down", era: "C# Standard", tuning: "Db", gauges: [".012",".016",".020",".034w",".046w",".056w"], scaleLength: 25.5, notes: "12–56 in C#. Down's crushing Southern doom tone.", verified: true, genre: "Sludge" },
  { name: "Jimmy Bower", band: "Superjoint Ritual / Eyehategod", era: "C# / C Standard", tuning: "Db", gauges: [".011",".014",".018",".028w",".042w",".056w"], scaleLength: 25.5, notes: "11–56 in C#. Sludge and power violence extremity.", verified: true, genre: "Sludge" },

  // ── C Standard ──────────────────────────────────────────────────────────────
  { name: "Matt Pike", band: "Sleep / High on Fire", era: "C Standard", tuning: "C", gauges: [".012",".016",".020",".036w",".046w",".056w"], scaleLength: 25.5, notes: "12–56. The tone of Dopesmoker. Les Paul into Orange stack.", verified: true, genre: "Sludge" },
  { name: "Sammy Duet", band: "Acid Bath / Goatwhore", era: "C Standard", tuning: "C", gauges: [".012",".016",".020",".034w",".046w",".060w"], scaleLength: 25.5, notes: "12–60. Used across Acid Bath and Goatwhore records.", verified: true, genre: "Sludge" },
  { name: "Jimmy Bower", band: "Eyehategod", era: "C Standard", tuning: "C", gauges: [".011",".014",".018",".028w",".042w",".056w"], scaleLength: 25.5, notes: "11–56. Feedback-drenched New Orleans sludge.", verified: true, genre: "Sludge" },
  { name: "Phil Caivano", band: "Monster Magnet", era: "C Standard", tuning: "C", gauges: [".013",".017",".026w",".036w",".046w",".060w"], scaleLength: 25.5, notes: "13–60 in C. Thick psychedelic sludge tone.", verified: true, genre: "Stoner" },
  { name: "Garrett Morris", band: "Windhand", era: "C Standard", tuning: "C", gauges: [".011",".014",".018",".028w",".040w",".054w"], scaleLength: 25.5, notes: "11–54. Windhand's hypnotic doom haze.", verified: true, genre: "Doom" },

  // ── B Standard ──────────────────────────────────────────────────────────────
  { name: "Kirk Windstein", band: "Crowbar / Down", era: "B Standard", tuning: "B", gauges: [".013",".017",".022w",".036w",".046w",".056w"], scaleLength: 24.75, notes: "13–56. Crowbar and Down's crushing low end. SG and Les Paul.", verified: true, genre: "Sludge" },
  { name: "Thomas V Jäger", band: "Monolord", era: "B Standard", tuning: "B", gauges: [".011",".014",".018",".028w",".042w",".056w"], scaleLength: 25.5, notes: "11–56 D'Addario Chrome Flatwound. Monolord's massive fuzz wall.", verified: true, genre: "Doom" },
  { name: "Jus Oborn", band: "Electric Wizard", era: "Come My Fanatics – present", tuning: "B", gauges: [".012",".016",".020",".034w",".046w",".060w"], scaleLength: 24.75, notes: "Switched to B Standard from Come My Fanatics onward. Les Paul.", verified: true, genre: "Doom" },

  // ── A# Standard ─────────────────────────────────────────────────────────────
  { name: "Wata", band: "Boris", era: "A# Standard", tuning: "Bb", gauges: [".011",".016",".026w",".036w",".046w",".060w"], scaleLength: 25.5, notes: "11–60. Boris's massive wall-of-sound drone approach.", verified: true, genre: "Drone" },

  // ── A Standard ──────────────────────────────────────────────────────────────
  { name: "Mike Scheidt", band: "YOB", era: "A Standard", tuning: "A", gauges: [".014",".018",".026w",".044w",".056w",".068w"], scaleLength: 25.5, notes: "14–68. YOB's meditative ultra-doom. Massive strings for A Standard.", verified: true, genre: "Doom" },

  // ── Drop A ───────────────────────────────────────────────────────────────────
  { name: "Greg Anderson", band: "Burning Witch / Goatsnake / Sunn O)))", era: "Drop A", tuning: "DropA", gauges: [".012",".016",".020",".036w",".052w",".064w"], scaleLength: 25.5, notes: "12–64. Used across Burning Witch, Goatsnake and early Sunn O))) material.", verified: true, genre: "Drone" },
  { name: "Stephen O'Malley", band: "Sunn O)))", era: "Drop A", tuning: "DropA", gauges: [".017",".024",".036w",".046w",".056w",".074w"], scaleLength: 25.5, notes: "Custom set: .017p, .024p, .036, .046, .056, .074 — D'Addario Chrome Flatwound. Maximum drone mass.", verified: true, genre: "Drone" },
  { name: "Kirk Windstein", band: "Crowbar", era: "Drop A", tuning: "DropA", gauges: [".013",".017",".022w",".036w",".046w",".056w"], scaleLength: 24.75, notes: "13–56 in Drop A. Crowbar's heaviest low end.", verified: true, genre: "Sludge" },

  // ── Drop F ───────────────────────────────────────────────────────────────────
  { name: "Jon Davis", band: "Conan", era: "Drop F", tuning: "DropF", gauges: [".014",".018",".036w",".052w",".070w",".080w"], scaleLength: 25.5, notes: "Custom set for Conan's prehistoric doom. Utterly brutal low end.", verified: true, genre: "Doom" },

  // ── F Standard ───────────────────────────────────────────────────────────────
  { name: "Dennis Pleckham", band: "Bongripper", era: "F Standard", tuning: "F", gauges: [".016",".024",".034w",".046w",".064w",".080w"], scaleLength: 25.5, notes: "From Ernie Ball 8-string set. Bongripper's subterranean instrumental doom.", verified: true, genre: "Doom" },
  // ── Classic Rock / Blues ────────────────────────────────────────────────────
  { name: "Jimi Hendrix", band: "The Jimi Hendrix Experience", era: "All eras", tuning: "Eb", gauges: [".010",".013",".015",".026w",".032w",".038w"], scaleLength: 25.5, notes: "Custom light set — Fender Rock N Roll 150 strings. Tuned to Eb to ease bending and suit his voice. Light bass strings, slightly heavier trebles.", verified: true, genre: "Rock" },
  { name: "Stevie Ray Vaughan", band: "Double Trouble", era: "All eras", tuning: "Eb", gauges: [".013",".015",".019",".028w",".038w",".058w"], scaleLength: 25.5, notes: "Custom GHS Nickel Rockers built by tech Rene Martinez — plain .019 G string. Tuned to Eb to ease tension. Legendary tone came from heavy attack, not heavy tuning.", verified: true, genre: "Blues" },
  { name: "Jimmy Page", band: "Led Zeppelin", era: "All eras", tuning: "E", gauges: [".008",".008",".010",".020w",".028w",".038w"], scaleLength: 24.75, notes: "Famously light — played .008s on his 24.75″ Les Paul. Compensated with high action for tone and dynamics.", verified: true, genre: "Rock" },
  { name: "Eric Clapton", band: "Cream / Solo", era: "Post-2000s", tuning: "E", gauges: [".010",".013",".017",".026w",".036w",".046w"], scaleLength: 25.5, notes: "Ernie Ball Regular Slinky 10-46. Settled on 10s after years of experimentation with Cream-era heavy sets.", verified: true, genre: "Blues" },
  { name: "Billy Gibbons", band: "ZZ Top", era: "All eras", tuning: "E", gauges: [".007",".009",".011",".019w",".028w",".035w"], scaleLength: 24.75, notes: "Famously uses .007 gauge — lighter than anyone expected for such a thick tone. B.B. King advised him to go lighter. Fat tone comes from technique and Les Paul, not gauge.", verified: true, genre: "Blues" },
  { name: "David Gilmour", band: "Pink Floyd", era: "The Wall onwards", tuning: "E", gauges: [".010",".012",".016",".028w",".038w",".048w"], scaleLength: 25.5, notes: "GHS Boomers 10-48 — his signature Blue Set. Custom gauges allowing wide bends while maintaining tone on the low end.", verified: true, genre: "Rock" },
  { name: "Mark Knopfler", band: "Dire Straits", era: "All eras", tuning: "E", gauges: [".009",".011",".016",".024w",".032w",".042w"], scaleLength: 25.5, notes: "Fingerpicking style on 9s. Light gauge suits his touch-sensitive right-hand technique. Primarily Stratocaster.", verified: true, genre: "Rock" },
  { name: "Keith Richards", band: "The Rolling Stones", era: "Open G era", tuning: "OpenG", gauges: [".011",".013",".017",".026w",".036w",".046w"], scaleLength: 25.5, notes: "5-string open G — removes the low E entirely. Used medium gauges for rhythm authority. Heavy rhythm attack.", verified: true, genre: "Rock" },
  { name: "Angus Young", band: "AC/DC", era: "All eras", tuning: "E", gauges: [".009",".011",".016",".024w",".032w",".042w"], scaleLength: 24.75, notes: "9-42 Super Slinky Ernie Balls on a Gibson SG. Light gauge for fast single-note runs and bends.", verified: true, genre: "Rock" },
  { name: "Malcolm Young", band: "AC/DC", era: "All eras", tuning: "E", gauges: [".012",".016",".020",".032w",".044w",".056w"], scaleLength: 24.75, notes: "12-56 — extremely heavy for a rhythm player in standard tuning. Designed for pure chording authority and staying in tune under hard strumming.", verified: true, genre: "Rock" },
  { name: "Duane Allman", band: "Allman Brothers Band", era: "All eras", tuning: "E", gauges: [".010",".013",".015",".026w",".032w",".038w"], scaleLength: 25.5, notes: "Same Fender Rock N Roll 150 custom light set as Hendrix. Slide and lead playing on Stratocaster and Les Paul.", verified: true, genre: "Blues" },

  // ── Hard Rock / Heavy Metal ─────────────────────────────────────────────────
  { name: "James Hetfield", band: "Metallica", era: "Black Album onwards", tuning: "Eb", gauges: [".011",".014",".018",".028w",".038w",".048w"], scaleLength: 25.5, notes: "11-48 Ernie Ball Power Slinky. Tuned to Eb for most of Metallica's catalog. Heavy bottom for palm-muted chug, lighter top for lead work.", verified: true, genre: "Metal" },
  { name: "Kirk Hammett", band: "Metallica", era: "Current", tuning: "Eb", gauges: [".010",".013",".017",".026w",".036w",".046w"], scaleLength: 25.5, notes: "10-46 Ernie Ball Regular Slinky. Lighter than Hetfield for lead flexibility, same Eb tuning.", verified: true, genre: "Metal" },
  { name: "Slash", band: "Guns N' Roses / Solo", era: "All eras", tuning: "Eb", gauges: [".011",".014",".018",".028w",".038w",".048w"], scaleLength: 24.75, notes: "Ernie Ball 11-48 Power Slinky tuned to Eb. Extra tension compensates for the shorter Les Paul scale at Eb.", verified: true, genre: "Rock" },
  { name: "Eddie Van Halen", band: "Van Halen", era: "All eras", tuning: "Eb", gauges: [".009",".011",".016",".026w",".032w",".040w"], scaleLength: 25.5, notes: "Custom 9-40 set — initially Fender 150XL, later Ernie Ball. Tuned to Eb. Light gauge enabled his whammy bar techniques and tapping.", verified: true, genre: "Rock" },
  { name: "Zakk Wylde", band: "Ozzy Osbourne / Black Label Society", era: "All eras", tuning: "Eb", gauges: [".010",".013",".017",".036w",".052w",".060w"], scaleLength: 24.75, notes: "GHS Boomers 10-60 signature set — light top for leads and pinch harmonics, massively heavy bottom for low-end riff clarity.", verified: true, genre: "Metal" },
  { name: "Dave Mustaine", band: "Megadeth", era: "All eras", tuning: "Eb", gauges: [".010",".013",".017",".030w",".042w",".052w"], scaleLength: 25.5, notes: "Gibson signature 10-52 set. Eb tuning for most of Megadeth's catalog. Custom gauge for aggressive thrash riffing.", verified: true, genre: "Metal" },
  { name: "Dimebag Darrell", band: "Pantera", era: "Vulgar Display onwards", tuning: "D", gauges: [".009",".011",".016",".026w",".036w",".046w"], scaleLength: 25.5, notes: "DR Hi-Voltage 9-46 signature set. Tuned a whole step down (D standard) for Vulgar Display of Power onwards. Cowboys From Hell used near-standard.", verified: true, genre: "Metal" },
  { name: "Randy Rhoads", band: "Ozzy Osbourne", era: "All eras", tuning: "E", gauges: [".009",".011",".016",".026w",".036w",".046w"], scaleLength: 24.75, notes: "9-46 on Les Paul and custom Jackson. Standard tuning, classical-influenced precision playing.", verified: true, genre: "Metal" },
  { name: "Yngwie Malmsteen", band: "Rising Force / Solo", era: "All eras", tuning: "Eb", gauges: [".008",".011",".014",".022w",".032w",".046w"], scaleLength: 25.5, notes: "Fender signature 8-46. Ultra-light top strings for sweeping arpeggios and fast runs. Tuned to Eb.", verified: true, genre: "Metal" },
  { name: "Tom Morello", band: "Rage Against the Machine", era: "All eras", tuning: "E", gauges: [".010",".013",".017",".026w",".036w",".046w"], scaleLength: 25.5, notes: "10-46 standard. E standard for most RATM material. Known for using the guitar as a sound effects generator rather than for altered tunings.", verified: true, genre: "Metal" },
  { name: "Adam Jones", band: "Tool", era: "All eras", tuning: "DropD", gauges: [".010",".013",".017",".030w",".042w",".052w"], scaleLength: 24.75, notes: "Ernie Ball Skinny Top Heavy Bottom 10-52. Drop D for the majority of Tool songs. Gibson Les Paul Custom.", verified: true, genre: "Metal" },
  { name: "Josh Homme", band: "Kyuss / QOTSA", era: "Kyuss / early QOTSA", tuning: "C", gauges: [".011",".014",".018",".028w",".038w",".048w"], scaleLength: 25.5, notes: "11-48 Dunlop nickel wound. C Standard across Kyuss and early Queens of the Stone Age. Bass cabs for the famous low-end guitar tone.", verified: true, genre: "Stoner" },
  { name: "Kurt Cobain", band: "Nirvana", era: "All eras", tuning: "Eb", gauges: [".010",".013",".017",".026w",".036w",".046w"], scaleLength: 25.5, notes: "10-46 Ernie Ball Regular Slinky. Tuned to Eb. Simple setup for simple riffs — the tone came from the cheap guitars and pushed amps.", verified: true, genre: "Rock" },

  // ── Shred / Progressive ──────────────────────────────────────────────────────
  { name: "Steve Vai", band: "Solo / Whitesnake", era: "All eras", tuning: "E", gauges: [".009",".011",".016",".026w",".032w",".042w"], scaleLength: 25.5, notes: "9-42 Ernie Ball Super Slinky. E standard for most material. Light gauge for extreme whammy bar and legato technique.", verified: true, genre: "Rock" },
  { name: "Joe Satriani", band: "Solo", era: "All eras", tuning: "Eb", gauges: [".010",".013",".017",".026w",".036w",".046w"], scaleLength: 25.5, notes: "10-46 in Eb. Moved up from 9s when he began tuning down a half step. D'Addario strings.", verified: true, genre: "Rock" },
  { name: "Guthrie Govan", band: "The Aristocrats / Solo", era: "Current", tuning: "E", gauges: [".010",".013",".017",".026w",".036w",".046w"], scaleLength: 25.5, notes: "D'Addario NYXL 10-46. Confirmed via D'Addario artist page. Versatile gauge for his fusion/rock playing.", verified: true, genre: "Rock" },

  // ── Country / Americana ──────────────────────────────────────────────────────
  { name: "Albert Collins", band: "Solo", era: "All eras", tuning: "OpenF", gauges: [".010",".013",".017",".030w",".042w",".052w"], scaleLength: 25.5, notes: "Custom open F tuning with Skinny Top Heavy Bottom 10-52. Capo used extensively. Telecaster into Fender amp.", verified: true, genre: "Blues" },

  // ── Jazz ────────────────────────────────────────────────────────────────────
  { name: "Pat Metheny", band: "Pat Metheny Group", era: "All eras", tuning: "E", gauges: [".011",".014",".018",".026w",".036w",".046w"], scaleLength: 25.5, notes: "D'Addario flatwound .011 medium. Dark tone with tone control near zero on his Gibson ES-175 for the classic mellow jazz sound.", verified: true, genre: "Jazz" },
  { name: "George Benson", band: "Solo", era: "All eras", tuning: "E", gauges: [".012",".016",".020",".028w",".039w",".053w"], scaleLength: 24.75, notes: "Thomastik Infeld GB112 Jazz flatwound. Pure nickel, heavy top for his smooth jazz articulation and chordal approach.", verified: true, genre: "Jazz" },
  // ── Bass ─────────────────────────────────────────────────────────────────────
  { name: "Al Cisneros", band: "Sleep / Om", era: "Dopesmoker era – present", tuning: "C", gauges: [".045w",".065w",".080w",".100w"], scaleLength: 33.25, notes: "C Standard on Rickenbacker 4003AC (33.25\u2033 scale). Roundwound .045-.100. Sleep and Om both use C Standard. Rickenbacker into dual Ampeg SVT stacks.", verified: true, genre: "Doom", instrument: "bass" },
  { name: "Geezer Butler", band: "Black Sabbath", era: "Master of Reality – The End", tuning: "Db", gauges: [".050w",".070w",".095w",".115w"], scaleLength: 34.0, notes: "C# / C tuning throughout most of Sabbath career. DR Black Beauties .050-.115 (custom .115 low string made to spec). Fender Precision into Laney / Ashdown.", verified: true, genre: "Doom", instrument: "bass" },
  { name: "Cliff Burton", band: "Metallica", era: "Kill Em All – Master of Puppets", tuning: "E", gauges: [".035w",".055w",".070w",".090w"], scaleLength: 34.0, notes: "Rotosound Swing 66 RS66LB light gauge .035-.090 — confirmed on Aria tribute bass spec sheet. E standard throughout Metallica. Rickenbacker 4001 then Aria SB Black n Gold.", verified: true, genre: "Metal", instrument: "bass" },
  { name: "Jeff Matz", band: "High on Fire", era: "Death Is This Communion – present", tuning: "C", gauges: [".050w",".070w",".085w",".105w"], scaleLength: 35.0, notes: "C Standard (C-F-Bb-Eb). GHS Bass Boomers .050-.115. Dunable JM1 35\u2033 scale. Split signal: Ampeg SVT 8x10 + 70s Laney guitar amp for the dual-stack mass.", verified: true, genre: "Sludge", instrument: "bass" },
  { name: "Dixie Dave Collins", band: "Weedeater", era: "And Justice for Y’all – present", tuning: "D", gauges: [".045w",".065w",".080w",".100w"], scaleLength: 34.0, notes: "D Standard to match Dave Shepherd. Stock Squier P-Bass, strings left on until they break — dead flatwound tone. Dual Sunn heads (200W each) into 2x15 cabs, everything on 10 except treble at zero.", verified: true, genre: "Sludge", instrument: "bass" },
];

// ─── STRING PACK DATABASE ─────────────────────────────────────────────────────
// gauges: high→low, w = wound, p = plain (plain assumed if no suffix)
// barcodes: UPC codes where known
const STRING_PACKS = [
  // D'Addario Electric
  { id:"da-nyxl-0942",   brand:"D'Addario", line:"NYXL",        name:"NYXL 09-42",         type:"electric", gauges:[".009",".011",".016",".024w",".032w",".042w"], barcode:"019954191672" },
  { id:"da-nyxl-1046",   brand:"D'Addario", line:"NYXL",        name:"NYXL 10-46",         type:"electric", gauges:[".010",".013",".017",".026w",".036w",".046w"], barcode:"019954191689" },
  { id:"da-nyxl-1052",   brand:"D'Addario", line:"NYXL",        name:"NYXL 10-52",         type:"electric", gauges:[".010",".013",".017",".030w",".042w",".052w"], barcode:"019954191696" },
  { id:"da-nyxl-1156",   brand:"D'Addario", line:"NYXL",        name:"NYXL 11-56",         type:"electric", gauges:[".011",".014",".018",".030w",".044w",".056w"], barcode:"019954191702" },
  { id:"da-nyxl-1260",   brand:"D'Addario", line:"NYXL",        name:"NYXL 12-60",         type:"electric", gauges:[".012",".016",".020",".032w",".044w",".060w"], barcode:"019954191719" },
  { id:"da-nyxl-1368b",  brand:"D'Addario", line:"NYXL",        name:"NYXL 13-62 Baritone",type:"electric", gauges:[".013",".017",".022w",".034w",".046w",".062w"], barcode:"019954191726" },
  { id:"da-xt-0942",     brand:"D'Addario", line:"XT",          name:"XT 09-42",           type:"electric", gauges:[".009",".011",".016",".024w",".032w",".042w"], barcode:"019954195649" },
  { id:"da-xt-1046",     brand:"D'Addario", line:"XT",          name:"XT 10-46",           type:"electric", gauges:[".010",".013",".017",".026w",".036w",".046w"], barcode:"019954195656" },
  { id:"da-xt-1156",     brand:"D'Addario", line:"XT",          name:"XT 11-56",           type:"electric", gauges:[".011",".014",".018",".030w",".044w",".056w"], barcode:"019954195670" },
  // Ernie Ball Electric
  { id:"eb-2221",        brand:"Ernie Ball", line:"Super Slinky", name:"Super Slinky 09-42",type:"electric", gauges:[".009",".011",".016",".024w",".032w",".042w"], barcode:"749699002214" },
  { id:"eb-2222",        brand:"Ernie Ball", line:"Regular Slinky",name:"Regular Slinky 10-46",type:"electric",gauges:[".010",".013",".017",".026w",".036w",".046w"],barcode:"749699002221" },
  { id:"eb-2223",        brand:"Ernie Ball", line:"Power Slinky", name:"Power Slinky 11-48", type:"electric", gauges:[".011",".014",".018",".028w",".038w",".048w"], barcode:"749699002238" },
  { id:"eb-2215",        brand:"Ernie Ball", line:"Skinny/Heavy", name:"Skinny Top Heavy Bottom 10-52",type:"electric",gauges:[".010",".013",".017",".030w",".042w",".052w"],barcode:"749699002153" },
  { id:"eb-2627",        brand:"Ernie Ball", line:"Not Even Slinky",name:"Not Even Slinky 12-56",type:"electric",gauges:[".012",".016",".024w",".032w",".044w",".056w"],barcode:"749699002627" },
  { id:"eb-2804",        brand:"Ernie Ball", line:"Paradigm",    name:"Paradigm 09-42",     type:"electric", gauges:[".009",".011",".016",".024w",".032w",".042w"], barcode:"749699028048" },
  { id:"eb-2805",        brand:"Ernie Ball", line:"Paradigm",    name:"Paradigm 10-46",     type:"electric", gauges:[".010",".013",".017",".026w",".036w",".046w"], barcode:"749699028055" },
  { id:"eb-2808",        brand:"Ernie Ball", line:"Paradigm",    name:"Paradigm 11-54",     type:"electric", gauges:[".011",".014",".018",".030w",".042w",".054w"], barcode:"749699028086" },
  { id:"eb-2811",        brand:"Ernie Ball", line:"Paradigm",    name:"Paradigm 13-62",     type:"electric", gauges:[".013",".017",".022w",".030w",".044w",".062w"], barcode:"749699028116" },
  // Dunlop Electric
  { id:"du-dhp1046",     brand:"Dunlop",    line:"Heavy Core",   name:"Heavy Core 10-46",   type:"electric", gauges:[".010",".013",".017",".030w",".042w",".046w"], barcode:"710137068513" },
  { id:"du-dhp1148",     brand:"Dunlop",    line:"Heavy Core",   name:"Heavy Core 11-48",   type:"electric", gauges:[".011",".015",".019",".032w",".042w",".048w"], barcode:"710137068520" },
  { id:"du-dhp1254",     brand:"Dunlop",    line:"Heavy Core",   name:"Heavy Core 12-54",   type:"electric", gauges:[".012",".016",".020",".034w",".046w",".054w"], barcode:"710137068537" },
  { id:"du-dhp1358",     brand:"Dunlop",    line:"Heavy Core",   name:"Heavy Core 13-56",   type:"electric", gauges:[".013",".017",".022w",".034w",".046w",".056w"], barcode:"710137068544" },
  // Elixir Electric
  { id:"el-12027",       brand:"Elixir",    line:"Nanoweb",      name:"Nanoweb 09-42",      type:"electric", gauges:[".009",".011",".016",".024w",".032w",".042w"], barcode:"706290120273" },
  { id:"el-12052",       brand:"Elixir",    line:"Nanoweb",      name:"Nanoweb 10-46",      type:"electric", gauges:[".010",".013",".017",".026w",".036w",".046w"], barcode:"706290120525" },
  { id:"el-12077",       brand:"Elixir",    line:"Nanoweb",      name:"Nanoweb 11-49",      type:"electric", gauges:[".011",".014",".018",".028w",".038w",".049w"], barcode:"706290120778" },
  // D'Addario Bass
  { id:"da-b-xl170",     brand:"D'Addario", line:"XL Nickel",    name:"XL Bass 45-100",     type:"bass",     gauges:[".045w",".065w",".080w",".100w"], barcode:"019954221706" },
  { id:"da-b-xl170-5",   brand:"D'Addario", line:"XL Nickel",    name:"XL Bass 5-str 45-130",type:"bass",   gauges:[".045w",".065w",".080w",".100w",".130w"], barcode:"019954221805" },
  { id:"da-b-nyxl45100", brand:"D'Addario", line:"NYXL Bass",    name:"NYXL Bass 45-100",   type:"bass",     gauges:[".045w",".065w",".080w",".100w"], barcode:"019954193591" },
  // Ernie Ball Bass
  { id:"eb-b-2831",      brand:"Ernie Ball", line:"Regular Slinky Bass",name:"Regular Slinky Bass 50-105",type:"bass",gauges:[".050w",".070w",".085w",".105w"],barcode:"749699028314" },
  { id:"eb-b-2832",      brand:"Ernie Ball", line:"Super Slinky Bass",  name:"Super Slinky Bass 40-95", type:"bass",gauges:[".040w",".060w",".075w",".095w"],barcode:"749699028321" },
];

// ─── RETAILERS ────────────────────────────────────────────────────────────────
// Replace AFFILIATE_TAG values with your actual affiliate/tracking IDs
const RETAILERS = [
  {
    name: "Sweetwater",
    icon: "🎸",
    color: "#ff6b35",
    // Replace YOUR_SWEETWATER_TAG with your Sweetwater affiliate ID
    buildUrl: (searchTerm) => `https://www.sweetwater.com/store/search.php?s=${encodeURIComponent(searchTerm)}&utm_source=YOUR_SWEETWATER_TAG`,
  },
  {
    name: "Amazon",
    icon: "📦",
    color: "#ff9900",
    // Replace YOUR_AMAZON_TAG with your Amazon Associates tag (format: yourtag-20)
    buildUrl: (searchTerm) => `https://www.amazon.com/s?k=${encodeURIComponent(searchTerm)}&tag=YOUR_AMAZON_TAG`,
  },
  {
    name: "Thomann",
    icon: "🇩🇪",
    color: "#c00",
    // Replace YOUR_THOMANN_TAG with your Thomann affiliate tag
    buildUrl: (searchTerm) => `https://www.thomann.de/gb/search_dir.html?sw=${encodeURIComponent(searchTerm)}&aff=YOUR_THOMANN_TAG`,
  },
  {
    name: "Guitar Center",
    icon: "🎵",
    color: "#cc0000",
    // Replace YOUR_GC_TAG with your Guitar Center affiliate/impact tag
    buildUrl: (searchTerm) => `https://www.guitarcenter.com/search?Ntt=${encodeURIComponent(searchTerm)}&affid=YOUR_GC_TAG`,
  },
  {
    name: "Strings Direct",
    icon: "🇬🇧",
    color: "#4488ff",
    // Replace YOUR_SD_TAG with your Strings Direct affiliate tag
    buildUrl: (searchTerm) => `https://www.stringsdirect.co.uk/search?q=${encodeURIComponent(searchTerm)}&ref=YOUR_SD_TAG`,
  },
];

// Build a search term from gauge output for retailer search
function buildSearchTerm(brand, gauges) {
  if (brand) return brand;
  const first = gauges[0] ? gauges[0].replace(/[wp]/g,'') : "";
  const last  = gauges[gauges.length-1] ? gauges[gauges.length-1].replace(/[wp]/g,'') : "";
  const firstNum = Math.round(parseFloat(first) * 1000);
  const lastNum  = Math.round(parseFloat(last) * 1000);
  return `electric guitar strings ${firstNum}-${lastNum}`;
}

// Score how well a pack matches a set of gauges (lower = better match)
function scorePackMatch(packGauges, targetGauges) {
  if (packGauges.length !== targetGauges.length) return Infinity;
  let score = 0;
  packGauges.forEach((pg, i) => {
    const pv = parseFloat(pg);
    const tv = parseFloat((targetGauges[i] || "0").replace(/[wp]/g, ""));
    score += Math.abs(pv - tv);
  });
  return score;
}

// ─── STRING / TUNING DATA ──────────────────────────────────────────────────────
const GUITAR_SCALES = [24.0, 24.625, 24.75, 25.0, 25.5, 26.0, 26.5, 27.0, 27.5, 28.0, 28.5, 29.0, 29.5, 30.0, 30.5, 31.0, 31.5, 32.0];
const BASS_SCALES   = [30.0, 30.5, 32.0, 33.0, 34.0, 35.0, 36.0];

const GUITAR_STRING_NAMES = {
  6: ["e1","B2","G3","D4","A5","E6"],
  7: ["e1","B2","G3","D4","A5","E6","B7"],
  8: ["e1","B2","G3","D4","A5","E6","B7","F#8"],
};
const BASS_STRING_NAMES = {
  4: ["G1","D2","A3","E4"],
  5: ["G1","D2","A3","E4","B5"],
  6: ["C1","G2","D3","A4","E5","B6"],
};

// ── Note frequency table (Hz) ──────────────────────────────────────────────────
const NF = {
  "F2":43.65,"F#2":46.25,"Gb2":46.25,"G2":49.00,"Ab2":51.91,"Db2":34.65,
  "A2":55.00,"Bb2":58.27,"B2":61.74,"C3":65.41,"C#3":69.30,"Db3":69.30,
  "D3":73.42,"Eb3":77.78,"Db4":138.59,"E3":82.41,
  "F3":87.31,"F#3":92.50,"Gb3":92.50,"G3":98.00,"Ab3":103.83,"A3":110.00,"Bb3":116.54,
  "B3":123.47,"C4":130.81,"C#4":138.59,"D4":146.83,"Eb4":155.56,"E4":164.81,
  "F4":174.61,"F#4":185.00,"Gb4":185.00,"G4":196.00,"Ab4":207.65,"A4":220.00,"Bb4":233.08,
  "B4":246.94,"C5":261.63,"C#5":277.18,"Db5":277.18,"D5":293.66,"Eb5":311.13,"E5":329.63,
  "F5":349.23,"F#5":369.99,"Gb5":369.99,"G5":392.00,
};
// helper to resolve note name → Hz
function nf(n) { return NF[n] || 82.41; }

// ── Comprehensive tuning list ─────────────────────────────────────────────────
// Each entry: { id, label, group, notes: [high→low Hz for 6-string guitar] }
// Bass versions scaled -1 octave (÷2) where applicable via getStringFreqs
const TUNING_LIST = [
  // ── STANDARD ──
  { id:"E",   label:"E Standard",   group:"Standard", names6:["e","B","G","D","A","E"], notes:[nf("E5"),nf("B4"),nf("G4"),nf("D4"),nf("A3"),nf("E3")] },
  { id:"Eb",  label:"Eb Standard",  group:"Standard", names6:["eb","Bb","G","Db","Ab","Eb"], notes:[nf("Eb5"),nf("Bb4"),nf("G4"),nf("Db4"),nf("Ab3"),nf("Eb3")] },
  { id:"D",   label:"D Standard",   group:"Standard", names6:["d","A","F#","C","G","D"], notes:[nf("D5"),nf("A4"),nf("F#4"),nf("C4"),nf("G3"),nf("D3")] },
  { id:"C#",  label:"C# Standard",  group:"Standard", names6:["c#","Ab","F","B","F#","C#"], notes:[nf("C#5"),nf("Ab4"),nf("F4"),nf("B3"),nf("F#3"),nf("C#3")] },
  { id:"C",   label:"C Standard",   group:"Standard", names6:["c","G","Eb","Bb","F","C"], notes:[nf("C5"),nf("G4"),nf("Eb4"),nf("Bb3"),nf("F3"),nf("C3")] },
  { id:"B",   label:"B Standard",   group:"Standard", names6:["b","F#","D","A","E","B"], notes:[nf("B4"),nf("F#4"),nf("D4"),nf("A3"),nf("E3"),nf("B2")] },
  { id:"Bb",  label:"Bb Standard",  group:"Standard", names6:["bb","F","Db","Ab","Eb","Bb"], notes:[nf("Bb4"),nf("F4"),nf("Db4"),nf("Ab3"),nf("Eb3"),nf("Bb2")] },
  { id:"A",   label:"A Standard",   group:"Standard", names6:["a","E","C","G","D","A"], notes:[nf("A4"),nf("E4"),nf("C4"),nf("G3"),nf("D3"),nf("A2")] },
  { id:"Ab",  label:"Ab Standard",  group:"Standard", names6:["ab","Eb","B","Gb","Db","Ab"], notes:[nf("Ab4"),nf("Eb4"),nf("B3"),nf("Gb3"),nf("Db3"),nf("Ab2")] },
  { id:"G",   label:"G Standard",   group:"Standard", names6:["g","D","Bb","F","C","G"], notes:[nf("G4"),nf("D4"),nf("Bb3"),nf("F3"),nf("C3"),nf("G2")] },
  { id:"F#",  label:"F# Standard",  group:"Standard", names6:["f#","C#","A","E","B","F#"], notes:[nf("F#4"),nf("C#4"),nf("A3"),nf("E3"),nf("B2"),nf("F#2")] },
  { id:"F",   label:"F Standard",   group:"Standard", names6:["f","C","Ab","Eb","Bb","F"], notes:[nf("F4"),nf("C4"),nf("Ab3"),nf("Eb3"),nf("Bb2"),nf("F2")] },
  // ── DROP ──
  { id:"DropD",  label:"Drop D",    group:"Drop",     names6:["e","B","G","D","A","D"], notes:[nf("E5"),nf("B4"),nf("G4"),nf("D4"),nf("A3"),nf("D3")] },
  { id:"DropDb", label:"Drop Eb",   group:"Drop",     names6:["eb","Bb","Gb","Db","Ab","Db"], notes:[nf("Eb5"),nf("Bb4"),nf("Gb4"),nf("Db4"),nf("Ab3"),nf("Db3")] },
  { id:"DropC",  label:"Drop C",    group:"Drop",     names6:["d","A","F","C","G","C"], notes:[nf("D5"),nf("A4"),nf("F4"),nf("C4"),nf("G3"),nf("C3")] },
  { id:"DropC#", label:"Drop C#",   group:"Drop",     names6:["c#","Ab","E","B","F#","C#"], notes:[nf("C#5"),nf("Ab4"),nf("E4"),nf("B3"),nf("F#3"),nf("C#3")] },
  { id:"DropB",  label:"Drop B",    group:"Drop",     names6:["c#","Ab","E","B","F#","B"], notes:[nf("C#5"),nf("Ab4"),nf("E4"),nf("B3"),nf("F#3"),nf("B2")] },
  { id:"DropBb", label:"Drop Bb",   group:"Drop",     names6:["c","G","Eb","Bb","F","Bb"], notes:[nf("C5"),nf("G4"),nf("Eb4"),nf("Bb3"),nf("F3"),nf("Bb2")] },
  { id:"DropA",  label:"Drop A",    group:"Drop",     names6:["b","F#","D","A","E","A"], notes:[nf("B4"),nf("F#4"),nf("D4"),nf("A3"),nf("E3"),nf("A2")] },
  { id:"DropAb", label:"Drop Ab",   group:"Drop",     names6:["bb","F","Db","Ab","Eb","Ab"], notes:[nf("Bb4"),nf("F4"),nf("Db4"),nf("Ab3"),nf("Eb3"),nf("Ab2")] },
  { id:"DropG",  label:"Drop G",    group:"Drop",     names6:["a","E","C","G","D","G"], notes:[nf("A4"),nf("E4"),nf("C4"),nf("G3"),nf("D3"),nf("G2")] },
  { id:"DropF#", label:"Drop F#",   group:"Drop",     names6:["ab","Eb","B","F#","C#","F#"], notes:[nf("Ab4"),nf("Eb4"),nf("B3"),nf("F#3"),nf("C#3"),nf("F#2")] },
  { id:"DropF",  label:"Drop F",    group:"Drop",     names6:["g","D","Bb","F","C","F"], notes:[nf("G4"),nf("D4"),nf("Bb3"),nf("F3"),nf("C3"),nf("F2")] },
  // ── OPEN MAJOR ──
  { id:"OpenE",  label:"Open E",    group:"Open Major", names6:["e","B","Ab","E","B","E"], notes:[nf("E5"),nf("B4"),nf("Ab4"),nf("E4"),nf("B3"),nf("E3")] },
  { id:"OpenEb", label:"Open Eb",   group:"Open Major", names6:["eb","Bb","G","Eb","Bb","Eb"], notes:[nf("Eb5"),nf("Bb4"),nf("G4"),nf("Eb4"),nf("Bb3"),nf("Eb3")] },
  { id:"OpenD",  label:"Open D",    group:"Open Major", names6:["d","A","F#","D","A","D"], notes:[nf("D5"),nf("A4"),nf("F#4"),nf("D4"),nf("A3"),nf("D3")] },
  { id:"OpenC",  label:"Open C",    group:"Open Major", names6:["e","C","G","C","G","C"], notes:[nf("E5"),nf("C5"),nf("G4"),nf("C4"),nf("G3"),nf("C3")] },
  { id:"OpenBb", label:"Open Bb",   group:"Open Major", names6:["bb","F","D","Bb","F","Bb"], notes:[nf("Bb4"),nf("F4"),nf("D4"),nf("Bb3"),nf("F3"),nf("Bb2")] },
  { id:"OpenB",  label:"Open B",    group:"Open Major", names6:["b","F#","Eb","B","F#","B"], notes:[nf("B4"),nf("F#4"),nf("Eb4"),nf("B3"),nf("F#3"),nf("B2")] },
  { id:"OpenA",  label:"Open A",    group:"Open Major", names6:["e","C#","A","E","A","E"], notes:[nf("E5"),nf("C#5"),nf("A4"),nf("E4"),nf("A3"),nf("E3")] },
  { id:"OpenG",  label:"Open G",    group:"Open Major", names6:["d","B","G","D","G","D"], notes:[nf("D5"),nf("B4"),nf("G4"),nf("D4"),nf("G3"),nf("D3")] },
  { id:"OpenF",  label:"Open F",    group:"Open Major", names6:["c","A","F","C","F","C"], notes:[nf("C5"),nf("A4"),nf("F4"),nf("C4"),nf("F3"),nf("C3")] },
  // ── OPEN MINOR ──
  { id:"OpenEm", label:"Open Em",   group:"Open Minor", names6:["e","B","G","E","B","E"], notes:[nf("E5"),nf("B4"),nf("G4"),nf("E4"),nf("B3"),nf("E3")] },
  { id:"OpenDm", label:"Open Dm",   group:"Open Minor", names6:["d","A","F","D","A","D"], notes:[nf("D5"),nf("A4"),nf("F4"),nf("D4"),nf("A3"),nf("D3")] },
  { id:"OpenCm", label:"Open Cm",   group:"Open Minor", names6:["eb","C","G","C","G","C"], notes:[nf("Eb5"),nf("C5"),nf("G4"),nf("C4"),nf("G3"),nf("C3")] },
  { id:"OpenAm", label:"Open Am",   group:"Open Minor", names6:["e","C","A","E","A","E"], notes:[nf("E5"),nf("C5"),nf("A4"),nf("E4"),nf("A3"),nf("E3")] },
  { id:"OpenGm", label:"Open Gm",   group:"Open Minor", names6:["d","Bb","G","D","G","D"], notes:[nf("D5"),nf("Bb4"),nf("G4"),nf("D4"),nf("G3"),nf("D3")] },
  { id:"OpenFm", label:"Open Fm",   group:"Open Minor", names6:["c","Ab","F","C","F","C"], notes:[nf("C5"),nf("Ab4"),nf("F4"),nf("C4"),nf("F3"),nf("C3")] },
  // ── MODAL / DRONE ──
  { id:"DADGAD",   label:"DADGAD",    group:"Modal/Drone", names6:["D","A","G","D","A","D"], notes:[nf("D5"),nf("A4"),nf("G4"),nf("D4"),nf("A3"),nf("D3")] },
  { id:"DADFAD",   label:"DADf#AD",   group:"Modal/Drone", names6:["D","A","F#","D","A","D"], notes:[nf("D5"),nf("A4"),nf("F#4"),nf("D4"),nf("A3"),nf("D3")] },
  { id:"CGCGCD",   label:"CGCGCD",    group:"Modal/Drone", names6:["D","C","G","C","G","C"], notes:[nf("D5"),nf("C5"),nf("G4"),nf("C4"),nf("G3"),nf("C3")] },
  { id:"CGDGCD",   label:"CGDGCD",    group:"Modal/Drone", names6:["D","C","G","D","G","C"], notes:[nf("D5"),nf("C5"),nf("G4"),nf("D4"),nf("G3"),nf("C3")] },
  { id:"C6",       label:"C6",        group:"Modal/Drone", names6:["E","C","G","C","A","C"], notes:[nf("E5"),nf("C5"),nf("G4"),nf("C4"),nf("A3"),nf("C3")] },
];

// Flat id→tuning lookup
const TUNING_MAP = Object.fromEntries(TUNING_LIST.map(t => [t.id, t]));

// Returns note-name labels for each string given instrument, count, tuning
function getStringNames(instrument, stringCount, tuningId) {
  const tuning = TUNING_MAP[tuningId];
  const base6 = tuning ? tuning.names6 : ["e","B","G","D","A","E"];
  if (instrument === "bass") {
    // Bass standard names (E standard reference, shifted per tuning)
    const bassBase = { 4:["G","D","A","E"], 5:["G","D","A","E","B"], 6:["C","G","D","A","E","B"] };
    // Calculate semitone offset from E standard
    const stdFreq = (TUNING_MAP["E"]?.notes[5]) || 82.41;
    const curFreq = tuning?.notes[5] || stdFreq;
    const semis = Math.round(12 * Math.log2(curFreq / stdFreq));
    if (semis === 0) return bassBase[stringCount] || bassBase[4];
    // Shift note names by semitone offset
    const CHROMATIC = ["C","C#","D","Eb","E","F","F#","G","Ab","A","Bb","B"];
    const shift = (name) => {
      const idx = CHROMATIC.indexOf(name);
      if (idx === -1) return name;
      return CHROMATIC[((idx + semis) % 12 + 12) % 12];
    };
    return (bassBase[stringCount] || bassBase[4]).map(shift);
  }
  // 7-string: add B below the 6
  if (stringCount === 7) return [...base6, "B"];
  // 8-string: add B and F# below
  if (stringCount === 8) return [...base6, "B", "F#"];
  return base6;
}

// Groups for dropdown rendering
const TUNING_GROUPS = ["Standard","Drop","Open Major","Open Minor","Modal/Drone"];

// Legacy alias for artist data compatibility
const TUNINGS = TUNING_LIST.map(t => t.id);

function getStringFreqs(instrument, stringCount, tuningId) {
  const tuning = TUNING_MAP[tuningId];
  // 6-string guitar freqs are the canonical source
  const base6 = tuning ? tuning.notes : TUNING_MAP["E"].notes;
  if (instrument === "bass") {
    // Bass strings are ~1 octave below guitar equivalent positions, map by string count
    const bassPositions = { 4:[5,4,3,2], 5:[5,4,3,2,1], 6:[6,5,4,3,2,1] };
    const pos = bassPositions[stringCount] || bassPositions[4];
    // bass open notes roughly 1 octave below guitar strings 3-6 (indices 5,4,3,2)
    const bNF = {
      4:  [nf("G3"),nf("D3"),nf("A2"),nf("E2")],
      5:  [nf("G3"),nf("D3"),nf("A2"),nf("E2"),nf("B2")],
      6:  [nf("C4"),nf("G3"),nf("D3"),nf("A2"),nf("E2"),nf("B2")],
    };
    // For standard tunings shift bass by same semitone offset as guitar
    const stdNotes = TUNING_MAP["E"].notes;
    const semitoneOffset = tuning ? Math.round(12 * Math.log2((tuning.notes[5]||82.41) / (stdNotes[5]||82.41))) : 0;
    const ST = Math.pow(2, 1/12);
    return (bNF[stringCount] || bNF[4]).map(f => f * Math.pow(ST, semitoneOffset));
  }
  // For 7/8 string guitar, extend downward from the 6-string set
  if (stringCount === 7) {
    const ST = Math.pow(2, 1/12);
    // 7th string = 5 semitones below string 6
    return [...base6, base6[5] * Math.pow(ST, -5)];
  }
  if (stringCount === 8) {
    const ST = Math.pow(2, 1/12);
    return [...base6, base6[5] * Math.pow(ST, -5), base6[5] * Math.pow(ST, -10)];
  }
  return base6;
}

// ─── TENSION MATH ──────────────────────────────────────────────────────────────
// Unit weights (lb/in) from D'Addario published tension specifications.
// Plain steel follows UW ≈ 0.2215 * d^2 closely; wound strings are non-linear
// due to varying core/wrap ratios, so we use a per-gauge lookup table.
// ─── STRING TYPES ─────────────────────────────────────────────────────────────
// UW multiplier applied to wound strings only. Plain steel is type-agnostic.
// Values derived from D'Addario, GHS, and Rotosound published unit weight data.
const STRING_TYPES = [
  { id: "nickel",    label: "Nickel Wound",        short: "NW",   mult: 1.00, desc: "Standard electric. D'Addario XL, Ernie Ball Slinky." },
  { id: "nps",       label: "Nickel-Plated Steel",  short: "NPS",  mult: 1.04, desc: "Slightly brighter/stiffer than pure nickel. Ernie Ball Cobalt, GHS Boomers." },
  { id: "steel",     label: "Stainless Steel",      short: "SS",   mult: 1.08, desc: "Highest tension for gauge. Rotosound Swing 66, DR Hi-Beam." },
  { id: "halfwound", label: "Half Wound",           short: "HW",   mult: 1.06, desc: "Ground outer wrap. Lower friction, between round and flat feel." },
  { id: "flatwound", label: "Flatwound",            short: "FW",   mult: 1.20, desc: "Highest tension. Vintage tone, no finger noise. D'Addario Chromes, Thomastik Jazz." },
];
const DEFAULT_STRING_TYPE = "nickel";

const UW_PLAIN_COEFF = 0.2215; // plain steel: UW = coeff * d^2 (d in inches)

const UW_WOUND = {
  // gauge-in-thousandths → unit weight (lb/in), D'Addario nickel wound
  17: 0.000082571, 18: 0.000093170, 19: 0.000104030, 20: 0.000114600,
  21: 0.000125860, 22: 0.000131980, 24: 0.000154700, 26: 0.000126790,
  28: 0.000177040, 30: 0.000203940, 32: 0.000225290, 34: 0.000238870,
  36: 0.000239412, 38: 0.000277890, 40: 0.000306450, 42: 0.000336870,
  44: 0.000358980, 46: 0.000382803, 48: 0.000398240, 50: 0.000416520,
  52: 0.000453890, 54: 0.000487370, 56: 0.000524750, 58: 0.000562350,
  60: 0.000600840, 62: 0.000641200, 64: 0.000683200, 66: 0.000726600,
  68: 0.000771300, 70: 0.000817800, 72: 0.000866000, 74: 0.000916000,
  76: 0.000967700, 80: 0.001072000, 85: 0.001216000, 90: 0.001367000,
  95: 0.001525000,100: 0.001690000,105: 0.001862000,110: 0.002042000,
};

function getUW(gaugeStr, isWound, stringTypeMult = 1.0) {
  const d = parseFloat(gaugeStr);
  if (!d) return 0;
  if (!isWound) return UW_PLAIN_COEFF * d * d; // plain steel: type-agnostic
  // Wound: look up by gauge in thousandths, interpolate neighbours if needed
  const thou = Math.round(d * 1000);
  let uw;
  if (UW_WOUND[thou]) {
    uw = UW_WOUND[thou];
  } else {
    const keys = Object.keys(UW_WOUND).map(Number).sort((a,b)=>a-b);
    const lo = keys.filter(k => k <= thou).pop();
    const hi = keys.filter(k => k >= thou)[0];
    if (!lo) uw = UW_WOUND[hi];
    else if (!hi) uw = UW_WOUND[lo];
    else { const t = (thou - lo) / (hi - lo); uw = UW_WOUND[lo] + t * (UW_WOUND[hi] - UW_WOUND[lo]); }
  }
  return uw * stringTypeMult;
}

// T (lbs) = UW * (2 * L * F)^2 / 386.4
// UW = unit weight (lb/in), L = scale (in), F = frequency (Hz)
function calcTension(gaugeStr, isWound, scaleInches, freqHz, stringTypeMult = 1.0) {
  const uw = getUW(gaugeStr, isWound, stringTypeMult);
  if (!uw || !freqHz) return 0;
  return Math.round(uw * Math.pow(2 * scaleInches * freqHz, 2) / 386.4 * 10) / 10;
}
function calcTensionsArr(gauges, woundFlags, scaleLengths, freqs, stringTypeMult = 1.0) {
  // scaleLengths can be a single number or an array (multi-scale)
  return gauges.map((g, i) => {
    const L = Array.isArray(scaleLengths) ? scaleLengths[i] : scaleLengths;
    return calcTension(g, woundFlags[i], L, freqs[i], stringTypeMult);
  });
}

// ─── GAUGE STEPS ──────────────────────────────────────────────────────────────
const PLAIN_STEPS = [".007",".008",".0085",".009",".0095",".010",".011",".012",".013",".014",".015",".016",".017",".018",".019",".020"];
const WOUND_STEPS = [".017",".018",".019",".020",".021",".022",".024",".026",".028",".030",".032",".034",".036",".038",".040",".042",".044",".046",".048",".050",".052",".054",".056",".058",".060",".062",".064",".066",".068",".070",".072",".074",".080",".085",".090",".095",".100",".105",".110"];

function bumpGauge(val, wound, dir) {
  const steps = wound ? WOUND_STEPS : PLAIN_STEPS;
  const clean = val.replace(/[wp]$/, "");
  let idx = steps.indexOf(clean);
  if (idx === -1) idx = steps.reduce((bi, c, ci) => Math.abs(parseFloat(c) - parseFloat(clean)) < Math.abs(parseFloat(steps[bi]) - parseFloat(clean)) ? ci : bi, 0);
  return steps[Math.max(0, Math.min(steps.length - 1, idx + dir))];
}

function nearestStep(dRaw, wound) {
  const steps = wound ? WOUND_STEPS : PLAIN_STEPS;
  return steps.reduce((p, c) => Math.abs(parseFloat(c) - dRaw) < Math.abs(parseFloat(p) - dRaw) ? c : p);
}

function solveGauge(targetT, isWound, scaleInches, freqHz, stringTypeMult = 1.0) {
  // Invert T = UW * mult * (2*L*F)^2 / 386.4
  // For plain: UW = coeff*d^2 (plain is type-agnostic) → same formula
  // For wound: account for string type multiplier in the search
  if (!isWound) {
    const dRaw = Math.sqrt(targetT * 386.4 / (UW_PLAIN_COEFF * Math.pow(2 * scaleInches * freqHz, 2)));
    return nearestStep(dRaw, false);
  }
  // Wound: find the WOUND_STEPS entry whose tension (with type mult) is closest to targetT
  const steps = WOUND_STEPS;
  let best = steps[0], bestDiff = Infinity;
  for (const s of steps) {
    const t = calcTension(s, true, scaleInches, freqHz, stringTypeMult);
    const diff = Math.abs(t - targetT);
    if (diff < bestDiff) { bestDiff = diff; best = s; }
  }
  return best;
}

// ─── MULTI-SCALE HELPERS ───────────────────────────────────────────────────────
// Default per-string scale array (all equal) for a given count and single scale
function defaultPerStringScales(n, s) { return Array(n).fill(s); }

// ─── DISPLAY HELPERS ──────────────────────────────────────────────────────────
function tensionColor(t) {
  if (!t) return "#555";
  if (t < 12) return "#ff6b35";
  if (t < 16) return "#ffd700";
  if (t < 22) return "#7fff7f";
  if (t < 27) return "#7fffd4";
  return "#ff4466";
}
function tensionLabel(t) {
  if (!t) return "—";
  if (t < 12) return "LOOSE";
  if (t < 16) return "SLACK";
  if (t < 22) return "BALANCED";
  if (t < 27) return "FIRM";
  return "TIGHT";
}

// ─── CONSTANTS ────────────────────────────────────────────────────────────────
const DIAGNOSTICS = [
  { id: "floppy", label: "Too Floppy", icon: "〰", description: "Strings feel loose, won't intonate, buzzing everywhere", fixes: ["Go up 1–2 gauges on problem strings", "Increase scale length guitar", "Raise tuning a half step", "Try a multi-scale / fan fret instrument"] },
  { id: "stiff",  label: "Too Stiff",  icon: "━", description: "Hard to bend, fretting hand fatigue, picking feels resistant", fixes: ["Drop 1–2 gauges", "Try longer scale at lower pitch", "Consider a shorter scale guitar", "Check if nut slots are binding"] },
  { id: "uneven", label: "Uneven Tension", icon: "≋", description: "Some strings feel right, others fight you", fixes: ["Build a custom set string by string", "Balance wound vs plain transition carefully", "Consider wound G string", "Try a tapered-core set"] }
];

const POPULAR_PACKS = [
  { brand: "D'Addario", pack: "NYXL 10-46",           gauges: [".010",".013",".017",".026w",".036w",".046w"] },
  { brand: "Ernie Ball", pack: "Skinny Top Heavy Bottom", gauges: [".010",".013",".017",".030w",".042w",".052w"] },
  { brand: "D'Addario", pack: "NYXL 12-60",           gauges: [".012",".016",".020",".032w",".044w",".060w"] },
  { brand: "Ernie Ball", pack: "Paradigm 13-62",      gauges: [".013",".017",".022w",".030w",".044w",".062w"] },
];

const FEEL_OPTIONS = [
  { id: "butter",   label: "Butter Smooth",     icon: "◌", desc: "Low resistance, easy bends, barely there",         targetAvg: [12, 15] },
  { id: "balanced", label: "Balanced",           icon: "◍", desc: "Playable but present — the goldilocks zone",       targetAvg: [16, 20] },
  { id: "firm",     label: "Firm & Controlled",  icon: "●", desc: "Tight articulation, minimal flop, solid attack",   targetAvg: [21, 25] },
  { id: "tank",     label: "Tank Mode",          icon: "⬛", desc: "Maximum tension, machine-gun chugs, zero give",   targetAvg: [26, 32] },
];

// Build tension targets for Loose/Balanced/Tight
const BUILD_FEELS = [
  { id: "loose",    label: "Loose",    icon: "〰", desc: "Easy playability, light touch", color: "#ff6b35", target: 13 },
  { id: "balanced", label: "Balanced", icon: "◍",  desc: "Even, comfortable tension",     color: "#7fff7f", target: 15.5 },
  { id: "tight",    label: "Tight",    icon: "━",  desc: "Firm, punchy, high control",    color: "#7fffd4", target: 18 },
];

// Default wound patterns per instrument/string count
const DEFAULT_WOUND_GUITAR = {
  6: [false, false, false, true, true, true],
  7: [false, false, false, true, true, true, true],
  8: [false, false, false, true, true, true, true, true],
};
const DEFAULT_WOUND_BASS = {
  4: [false, true, true, true],
  5: [false, true, true, true, true],
  6: [false, false, true, true, true, true],
};

const DEFAULT_GAUGES_6  = [".010",".013",".017",".026",".036",".046"];
const DEFAULT_GAUGES_7  = [".010",".013",".017",".026",".036",".046",".060"];
const DEFAULT_GAUGES_8  = [".009",".011",".015",".020",".030",".042",".054",".070"];
const DEFAULT_GAUGES_B4 = [".045",".065",".085",".105"];
const DEFAULT_GAUGES_B5 = [".045",".065",".085",".105",".130"];
const DEFAULT_GAUGES_B6 = [".032",".045",".065",".085",".105",".130"];

const DEFAULT_GUITAR_GAUGES = { 6: DEFAULT_GAUGES_6, 7: DEFAULT_GAUGES_7, 8: DEFAULT_GAUGES_8 };
const DEFAULT_BASS_GAUGES   = { 4: DEFAULT_GAUGES_B4, 5: DEFAULT_GAUGES_B5, 6: DEFAULT_GAUGES_B6 };

// ─── STORAGE ──────────────────────────────────────────────────────────────────
const STORAGE_KEY = "downtune_v4";
function loadSaved() { try { const r = localStorage.getItem(STORAGE_KEY); return r ? JSON.parse(r) : []; } catch { return []; } }
function persist(s)  { try { localStorage.setItem(STORAGE_KEY, JSON.stringify(s)); } catch {} }

function parseGauge(s) {
  if (!s) return { val: ".010", wound: false };
  const wound = s.endsWith("w");
  const val = s.replace(/[wp]$/, "");
  return { val, wound };
}
function parseArtistGauges(gaugeArr) {
  const vals = [], wounds = [];
  gaugeArr.forEach(g => { const { val, wound } = parseGauge(g); vals.push(val); wounds.push(wound); });
  return { vals, wounds };
}

// ─── MAIN COMPONENT ───────────────────────────────────────────────────────────
// ─── STRING TYPE SELECTOR ─────────────────────────────────────────────────────
function StringTypeSelector({ value, onChange, accentColor = "#ff6b35" }) {
  const active = STRING_TYPES.find(t => t.id === value) || STRING_TYPES[0];
  return (
    <div style={{ marginBottom: 18 }}>
      <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#444", marginBottom: 8 }}>STRING TYPE</div>
      <div style={{ display: "flex", flexWrap: "wrap", gap: 5, marginBottom: 6 }}>
        {STRING_TYPES.map(t => (
          <button key={t.id} onClick={() => onChange(t.id)} style={{
            background: value === t.id ? "#111" : "#0a0a0a",
            border: `1px solid ${value === t.id ? accentColor : "#1e1e1e"}`,
            color: value === t.id ? accentColor : "#3a3a3a",
            borderRadius: 3, padding: "5px 10px", cursor: "pointer",
            fontSize: 9, fontWeight: 900, letterSpacing: "0.2em", whiteSpace: "nowrap",
            transition: "all 0.12s"
          }}>{t.short}</button>
        ))}
      </div>
      <div style={{ fontSize: 10, color: "#333", lineHeight: 1.5 }}>
        <span style={{ color: "#555", fontWeight: 700 }}>{active.label}</span>
        {active.mult !== 1.0 && <span style={{ color: accentColor, marginLeft: 6, fontSize: 9 }}>{`+${Math.round((active.mult - 1) * 100)}% wound tension`}</span>}
        {active.mult === 1.0 && <span style={{ color: "#333", marginLeft: 6, fontSize: 9 }}>baseline</span>}
        <span style={{ color: "#2a2a2a", marginLeft: 8 }}>{"· " + active.desc}</span>
      </div>
    </div>
  );
}

function DownTune() {
  // ── Calc state ──
  const [screen, setScreen] = useState("home");
  const [scaleLength, setScaleLength] = useState(24.75);
  const [stringType, setStringType] = useState(DEFAULT_STRING_TYPE);
  const [calcInstrument, setCalcInstrument] = useState("guitar");
  const [calcStringCount, setCalcStringCount] = useState(6);
  const [calcMultiScale, setCalcMultiScale] = useState(false);
  const [calcStringScales, setCalcStringScales] = useState(Array(6).fill(25.5));
  const [tuning, setTuning] = useState("C");
  const [gauges, setGauges] = useState([...DEFAULT_GAUGES_6]);
  const [woundFlags, setWoundFlags] = useState([...DEFAULT_WOUND_GUITAR[6]]);
  const [tensions, setTensions] = useState([]);
  const [selectedArtist, setSelectedArtist] = useState(null);
  const [activeDiag, setActiveDiag] = useState(null);
  const [generatedSet, setGeneratedSet] = useState(null);
  const [barcodeInput, setBarcodeInput] = useState("");
  const [scannerQuery, setScannerQuery] = useState("");
  const [scannerResults, setScannerResults] = useState([]);
  const [scannerFilter, setScannerFilter] = useState("all"); // "all" | "electric" | "bass"
  const [scannerBrand, setScannerBrand] = useState("all");
  const [scannerLoaded, setScannerLoaded] = useState(null); // pack that was loaded
  const [cameraActive, setCameraActive] = useState(false);
  const [cameraError, setCameraError] = useState("");
  const [scanDetecting, setScanDetecting] = useState(false);
  const [scanResult, setScanResult] = useState(null);
  const [iosCapture, setIosCapture] = useState(false);
  const [buyGauges, setBuyGauges] = useState([]);
  const [buyWound, setBuyWound] = useState([]);
  const [buyPackName, setBuyPackName] = useState("");
  const [filter, setFilter] = useState("All");
  const [artistSearch, setArtistSearch] = useState("");
  const [loaded, setLoaded] = useState(false);
  const [shared, setShared] = useState(false);

  // ── Save/load state ──
  const [savedSetups, setSavedSetups] = useState(() => loadSaved());
  const [renamingId, setRenamingId] = useState(null);
  const [renameVal, setRenameVal] = useState("");
  const [showSaveInput, setShowSaveInput] = useState(false);
  const [saveNameInput, setSaveNameInput] = useState("");
  const [showMatchSaveInput, setShowMatchSaveInput] = useState(false);
  const [matchSaveName, setMatchSaveName] = useState("");
  const [showBuildSaveInput, setShowBuildSaveInput] = useState(false);
  const [buildSaveName, setBuildSaveName] = useState("");

  // ── Match My Feel state ──
  const [srcInstrument, setSrcInstrument] = useState("guitar");
  const [srcStringCount, setSrcStringCount] = useState(6);
  const [srcGauges, setSrcGauges] = useState([...DEFAULT_GAUGES_6]);
  const [srcWound, setSrcWound] = useState([...DEFAULT_WOUND_GUITAR[6]]);
  const [srcTuning, setSrcTuning] = useState("E");
  const [srcScale, setSrcScale] = useState(25.5);
  const [srcMultiScale, setSrcMultiScale] = useState(false);
  const [srcStringScales, setSrcStringScales] = useState(Array(6).fill(25.5));
  const [srcTensions, setSrcTensions] = useState([]);
  const [tgtTuning, setTgtTuning] = useState("C");
  const [tgtScale, setTgtScale] = useState(25.5);
  const [tgtMultiScale, setTgtMultiScale] = useState(false);
  const [tgtStringScales, setTgtStringScales] = useState(Array(6).fill(25.5));
  const [tgtWound, setTgtWound] = useState([...DEFAULT_WOUND_GUITAR[6]]);
  const [tgtGauges, setTgtGauges] = useState([]);
  const [tgtTensions, setTgtTensions] = useState([]);
  const [matchGenerated, setMatchGenerated] = useState(false);

  // ── Build A Setup state ──
  const [buildInstrument, setBuildInstrument] = useState("guitar"); // "guitar" | "bass"
  const [buildStringCount, setBuildStringCount] = useState(6);
  const [buildTuning, setBuildTuning] = useState("E");
  const [buildFeel, setBuildFeel] = useState(null);
  const [buildMultiScale, setBuildMultiScale] = useState(false);
  const [buildStringScales, setBuildStringScales] = useState(Array(6).fill(25.5));
  const [buildSingleScale, setBuildSingleScale] = useState(25.5);
  const [buildResult, setBuildResult] = useState(null); // { gauges, wounds, tensions, scales, stringNames }

  useEffect(() => { setTimeout(() => setLoaded(true), 80); }, []);

  const stringTypeMult = (STRING_TYPES.find(t => t.id === stringType) || STRING_TYPES[0]).mult;

  // Calc tensions — instrument/string-count aware
  const calcFreqs = getStringFreqs(calcInstrument, calcStringCount, tuning);
  useEffect(() => {
    const scales = calcMultiScale ? calcStringScales.slice(0, calcStringCount) : scaleLength;
    setTensions(calcTensionsArr(gauges.slice(0, calcStringCount), woundFlags.slice(0, calcStringCount), scales, calcFreqs, stringTypeMult));
  }, [gauges, woundFlags, scaleLength, calcMultiScale, calcStringScales, tuning, stringTypeMult, calcInstrument, calcStringCount]);

  // Src tensions update live as user edits source setup
  useEffect(() => {
    const freqs = getStringFreqs(srcInstrument, srcStringCount, srcTuning);
    const scales = srcMultiScale ? srcStringScales.slice(0, srcStringCount) : srcScale;
    setSrcTensions(calcTensionsArr(srcGauges.slice(0, srcStringCount), srcWound.slice(0, srcStringCount), scales, freqs, stringTypeMult));
  }, [srcGauges, srcWound, srcScale, srcMultiScale, srcStringScales, srcTuning, stringTypeMult, srcInstrument, srcStringCount]);

  // Tgt tensions update live after generation + bumps
  useEffect(() => {
    if (!tgtGauges.length) return;
    const n = srcStringCount;
    const freqs = getStringFreqs(srcInstrument, n, tgtTuning);
    const scales = tgtMultiScale ? tgtStringScales.slice(0, n) : tgtScale;
    setTgtTensions(calcTensionsArr(tgtGauges, tgtWound, scales, freqs, stringTypeMult));
  }, [tgtGauges, tgtWound, tgtScale, tgtMultiScale, tgtStringScales, tgtTuning, stringTypeMult, srcInstrument, srcStringCount]);

  // ── Calc helpers ──
  // ── Instrument/count change helpers ──
  function changeCalcInstrument(inst) {
    const defaultCount = inst === "bass" ? 4 : 6;
    const defaultG = inst === "bass" ? DEFAULT_BASS_GAUGES[defaultCount] : DEFAULT_GUITAR_GAUGES[defaultCount];
    const defaultW = inst === "bass" ? DEFAULT_WOUND_BASS[defaultCount] : DEFAULT_WOUND_GUITAR[defaultCount];
    setCalcInstrument(inst); setCalcStringCount(defaultCount);
    setGauges([...defaultG]); setWoundFlags([...defaultW]);
  }
  function changeCalcCount(n) {
    const defaultG = calcInstrument === "bass" ? DEFAULT_BASS_GAUGES[n] : DEFAULT_GUITAR_GAUGES[n];
    const defaultW = calcInstrument === "bass" ? DEFAULT_WOUND_BASS[n] : DEFAULT_WOUND_GUITAR[n];
    setCalcStringCount(n);
    setGauges([...defaultG]); setWoundFlags([...defaultW]);
  }
  function changeSrcInstrument(inst) {
    const defaultCount = inst === "bass" ? 4 : 6;
    const defaultG = inst === "bass" ? DEFAULT_BASS_GAUGES[defaultCount] : DEFAULT_GUITAR_GAUGES[defaultCount];
    const defaultW = inst === "bass" ? DEFAULT_WOUND_BASS[defaultCount] : DEFAULT_WOUND_GUITAR[defaultCount];
    setSrcInstrument(inst); setSrcStringCount(defaultCount);
    setSrcGauges([...defaultG]); setSrcWound([...defaultW]); setMatchGenerated(false);
  }
  function changeSrcCount(n) {
    const defaultG = srcInstrument === "bass" ? DEFAULT_BASS_GAUGES[n] : DEFAULT_GUITAR_GAUGES[n];
    const defaultW = srcInstrument === "bass" ? DEFAULT_WOUND_BASS[n] : DEFAULT_WOUND_GUITAR[n];
    setSrcStringCount(n);
    setSrcGauges([...defaultG]); setSrcWound([...defaultW]); setMatchGenerated(false);
  }

  function bump(i, dir) { const ng = [...gauges]; ng[i] = bumpGauge(gauges[i], woundFlags[i], dir); setGauges(ng); }
  function toggleWound(i) {
    const nw = [...woundFlags]; nw[i] = !nw[i]; setWoundFlags(nw);
    const ng = [...gauges];
    const steps = nw[i] ? WOUND_STEPS : PLAIN_STEPS;
    ng[i] = steps.reduce((p, c) => Math.abs(parseFloat(c) - parseFloat(ng[i])) < Math.abs(parseFloat(p) - parseFloat(ng[i])) ? c : p);
    setGauges(ng);
  }
  function bumpSrc(i, dir) { const ng = [...srcGauges]; ng[i] = bumpGauge(srcGauges[i], srcWound[i], dir); setSrcGauges(ng); setMatchGenerated(false); }
  function toggleSrcWound(i) {
    const nw = [...srcWound]; nw[i] = !nw[i]; setSrcWound(nw);
    const ng = [...srcGauges];
    const steps = nw[i] ? WOUND_STEPS : PLAIN_STEPS;
    ng[i] = steps.reduce((p, c) => Math.abs(parseFloat(c) - parseFloat(ng[i])) < Math.abs(parseFloat(p) - parseFloat(ng[i])) ? c : p);
    setSrcGauges(ng); setMatchGenerated(false);
  }
  function bumpTgt(i, dir) { const ng = [...tgtGauges]; ng[i] = bumpGauge(tgtGauges[i], tgtWound[i], dir); setTgtGauges(ng); }
  function toggleTgtWound(i) {
    const nw = [...tgtWound]; nw[i] = !nw[i]; setTgtWound(nw);
    const ng = [...tgtGauges];
    const steps = nw[i] ? WOUND_STEPS : PLAIN_STEPS;
    ng[i] = steps.reduce((p, c) => Math.abs(parseFloat(c) - parseFloat(ng[i])) < Math.abs(parseFloat(p) - parseFloat(ng[i])) ? c : p);
    setTgtGauges(ng);
  }

  function loadArtist(artist) {
    const { vals, wounds } = parseArtistGauges(artist.gauges);
    setSelectedArtist(artist); setGauges(vals); setWoundFlags(wounds);
    setScaleLength(artist.scaleLength);
    if (TUNING_MAP[artist.tuning]) setTuning(artist.tuning);
    setScreen("detail");
  }

  // ── Scanner helpers ──
  function runScannerSearch(q, type, brand) {
    const query = (q || scannerQuery).toLowerCase().trim();
    const filterType = type !== undefined ? type : scannerFilter;
    const filterBrand = brand !== undefined ? brand : scannerBrand;
    let results = [...STRING_PACKS];
    if (filterType !== "all") results = results.filter(p => p.type === filterType);
    if (filterBrand !== "all") results = results.filter(p => p.brand === filterBrand);
    if (query) results = results.filter(p =>
      p.name.toLowerCase().includes(query) ||
      p.brand.toLowerCase().includes(query) ||
      p.line.toLowerCase().includes(query) ||
      p.barcode.includes(query) ||
      p.gauges.some(g => g.includes(query))
    );
    setScannerResults(results);
  }

  function loadPack(pack) {
    const { vals, wounds } = parseArtistGauges(pack.gauges);
    // Pad or trim to 6 strings
    const g6 = Array(6).fill(".010");
    const w6 = [...DEFAULT_WOUND_GUITAR[6]];
    vals.forEach((v, i) => { if (i < 6) { g6[i] = v; w6[i] = wounds[i]; } });
    setGauges(g6); setWoundFlags(w6);
    setScannerLoaded(pack);
    setScreen("calculator");
  }

  // Lookup barcode string in our database
  function handleBarcodeDetected(code) {
    setScanDetecting(false);
    const match = STRING_PACKS.find(p => p.barcode === code.trim());
    if (match) {
      setScanResult({ pack: match, code });
      loadPack(match);
      setCameraActive(false);
    } else {
      // Show the raw code so user can search manually
      setScanResult({ pack: null, code });
      setScannerQuery(code);
      runScannerSearch(code);
      setCameraActive(false);
    }
  }

  // BarcodeDetector loop (Android Chrome + desktop Chrome)
  function startBarcodeLoop(videoEl) {
    if (!("BarcodeDetector" in window)) return;
    const detector = new window.BarcodeDetector({ formats: ["ean_13", "ean_8", "upc_a", "upc_e", "code_128", "code_39"] });
    let running = true;
    async function tick() {
      if (!running || videoEl.readyState < 2) { if (running) requestAnimationFrame(tick); return; }
      try {
        const barcodes = await detector.detect(videoEl);
        if (barcodes.length > 0) { running = false; handleBarcodeDetected(barcodes[0].rawValue); return; }
      } catch(_) {}
      if (running) requestAnimationFrame(tick);
    }
    setScanDetecting(true);
    requestAnimationFrame(tick);
    return () => { running = false; };
  }

  // iOS fallback — file input capture
  function handleImageCapture(e) {
    const file = e.target.files?.[0];
    if (!file) return;
    if (!("BarcodeDetector" in window)) {
      setCameraError("Auto-detect not supported on this browser. Search manually below.");
      return;
    }
    const detector = new window.BarcodeDetector({ formats: ["ean_13","ean_8","upc_a","upc_e","code_128","code_39"] });
    createImageBitmap(file).then(bmp => {
      detector.detect(bmp).then(barcodes => {
        if (barcodes.length > 0) handleBarcodeDetected(barcodes[0].rawValue);
        else setCameraError("No barcode found in photo. Try again closer.");
      });
    }).catch(() => setCameraError("Couldn't read image. Try again."));
    setIosCapture(false);
  }

  function stopCamera() {
    setCameraActive(false);
    setScanDetecting(false);
  }

  function generateSet() {
    const set = gauges.slice(0, calcStringCount).map((g, i) => ({ string: (calcInstrument === "bass" ? BASS_STRING_NAMES[calcStringCount] : GUITAR_STRING_NAMES[calcStringCount])[i], gauge: g, wound: woundFlags[i], tension: tensions[i] || 0 }));
    setGeneratedSet(set); setScreen("generated");
  }

  function generateSetFromBuild() {
    if (!buildResult) return;
    const set = buildResult.stringNames.map((name, i) => ({
      string: name, gauge: buildResult.gauges[i], wound: buildResult.wounds[i], tension: buildResult.tensions[i] || 0
    }));
    setGeneratedSet(set); setScreen("generated");
  }

  function generateSetFromMatch() {
    if (!tgtGauges.length) return;
    const names = srcInstrument === "bass" ? BASS_STRING_NAMES[srcStringCount] : GUITAR_STRING_NAMES[srcStringCount];
    const set = names.map((name, i) => ({
      string: name, gauge: tgtGauges[i] || "—", wound: tgtWound[i], tension: tgtTensions[i] || 0
    }));
    setGeneratedSet(set); setScreen("generated");
  }

  // ── Save/load helpers ──
  function saveSetup(name, source) {
    let g, w, sl, t;
    if (source === "match") { g = tgtGauges.length ? tgtGauges : srcGauges; w = tgtGauges.length ? tgtWound : srcWound; sl = tgtScale; t = tgtTuning; }
    else if (source === "build" && buildResult) { g = buildResult.gauges; w = buildResult.wounds; sl = buildMultiScale ? buildStringScales.join(",") : buildSingleScale; t = buildTuning; }
    else { g = gauges; w = woundFlags; sl = scaleLength; t = tuning; }
    const setup = { id: Date.now(), name: name || `Setup ${savedSetups.length + 1}`, gauges: g, woundFlags: w, scaleLength: sl, tuning: t, savedAt: new Date().toLocaleDateString() };
    const updated = [setup, ...savedSetups].slice(0, 10);
    setSavedSetups(updated); persist(updated);
  }
  function deleteSetup(id) { const u = savedSetups.filter(s => s.id !== id); setSavedSetups(u); persist(u); }
  function renameSetup(id, name) {
    if (!name.trim()) return;
    const u = savedSetups.map(s => s.id === id ? { ...s, name: name.trim() } : s);
    setSavedSetups(u); persist(u);
    setRenamingId(null); setRenameVal("");
  }
  function loadSetup(setup) {
    const w = setup.woundFlags || DEFAULT_WOUND_GUITAR[6];
    const sl = typeof setup.scaleLength === "number" ? setup.scaleLength : 25.5;
    // Load into calc
    setGauges(setup.gauges); setWoundFlags(w); setScaleLength(sl); setTuning(setup.tuning);
    // Load into match source
    setSrcGauges(setup.gauges); setSrcWound(w); setSrcScale(sl); setSrcTuning(setup.tuning);
    setMatchGenerated(false);
  }

  // ── Match My Feel generate ──
  function generateMatchFeel() {
    const isBass = srcInstrument === "bass";
    const n = srcStringCount;
    const freqs = getStringFreqs(srcInstrument, n, tgtTuning);
    const tgtScales = tgtMultiScale ? tgtStringScales.slice(0, n) : Array(n).fill(tgtScale);
    const plainMult = isBass ? 1.0 : 0.85;
    const results = freqs.map((f, i) =>
      solveStringAuto(srcTensions[i] || 15, tgtScales[i], f, isBass, i, plainMult, stringTypeMult)
    );
    setTgtWound(results.map(r => r.wound));
    setTgtGauges(results.map(r => r.gauge));
    setMatchGenerated(true);
  }

  // ── Build A Setup generate ──
  // ── Shared wound/plain auto-decision ────────────────────────────────────────
  // stringPos: 0-indexed from high to low (0=high e, 1=B, 2=G, ...)
  // Rules:
  //   - Bass: always wound
  //   - Positions 0 (e) and 1 (B): always plain — these are never wound on electric guitar
  //   - plain > .020" → force wound
  //   - wound < .017" → force plain
  //   - otherwise: whichever gauge hits target tension more closely
  // plainMult: target tension multiplier for plain strings (default 1.0 = same as wound)
  // Use ~0.85 for perceptually balanced sets (plain strings feel stiffer at same tension)
  function solveStringAuto(targetT, scaleIn, freqHz, isBass, stringPos = 2, plainMult = 1.0, stMult = 1.0) {
    if (isBass) return { gauge: solveGauge(targetT, true, scaleIn, freqHz), wound: true };

    // High e and B are always plain steel on electric guitar
    if (stringPos <= 1) {
      const pTarget = targetT * plainMult;
      return { gauge: solveGauge(pTarget, false, scaleIn, freqHz), wound: false };
    }

    // G and below: solve both, applying plain multiplier to plain target
    const pTarget = targetT * plainMult;
    const pGauge = solveGauge(pTarget, false, scaleIn, freqHz, stMult);
    const wGauge = solveGauge(targetT, true,  scaleIn, freqHz, stMult);
    const pD = parseFloat(pGauge), wD = parseFloat(wGauge);

    if (pD > 0.020) return { gauge: wGauge, wound: true };
    if (wD < 0.017) return { gauge: pGauge, wound: false };

    // Pick whichever hits its own target more closely
    const pT = calcTension(pGauge, false, scaleIn, freqHz, stringTypeMult);
    const wT = calcTension(wGauge, true,  scaleIn, freqHz, stringTypeMult);
    if (Math.abs(wT - targetT) < Math.abs(pT - pTarget))
      return { gauge: wGauge, wound: true };
    return { gauge: pGauge, wound: false };
  }

  function generateBuild() {
    if (!buildFeel) return;
    const numStrings = buildStringCount;
    const freqs = getStringFreqs(buildInstrument, numStrings, buildTuning);
    const scales = buildMultiScale
      ? buildStringScales.slice(0, numStrings)
      : Array(numStrings).fill(buildSingleScale);
    const targetT = buildFeel.target;
    const isBass = buildInstrument === "bass";
    // Plain strings target ~85% of wound tension — they feel stiffer at equal tension
    const plainMult = isBass ? 1.0 : 0.85;
    const results = freqs.map((f, i) => solveStringAuto(targetT, scales[i], f, isBass, i, plainMult, stringTypeMult));
    const builtGauges   = results.map(r => r.gauge);
    const builtWounds   = results.map(r => r.wound);
    const builtTensions = results.map((r, i) => calcTension(r.gauge, r.wound, scales[i], freqs[i], stringTypeMult));
    const stringNames = isBass ? BASS_STRING_NAMES[numStrings] : GUITAR_STRING_NAMES[numStrings];
    setBuildResult({ gauges: builtGauges, wounds: builtWounds, tensions: builtTensions, scales, stringNames, freqs });
  }

  // When instrument/stringCount changes, reset result and update defaults
  useEffect(() => {
    setBuildResult(null);
    const scalesArr = buildInstrument === "bass" ? BASS_SCALES : GUITAR_SCALES;
    const defaultScale = buildInstrument === "bass" ? 34.0 : 25.5;
    setBuildSingleScale(defaultScale);
    setBuildStringScales(Array(buildStringCount).fill(defaultScale));
  }, [buildInstrument, buildStringCount]);

  // ── Calc summary ──
  const avgTension = tensions.length ? (tensions.reduce((a, b) => a + b, 0) / tensions.length).toFixed(1) : "—";
  const totalTension = tensions.length ? tensions.reduce((a, b) => a + b, 0).toFixed(0) : "—";
  const srcAvgTension = srcTensions.length ? (srcTensions.reduce((a, b) => a + b, 0) / srcTensions.length).toFixed(1) : "—";
  const tgtAvgTension = tgtTensions.length ? (tgtTensions.reduce((a, b) => a + b, 0) / tgtTensions.length).toFixed(1) : "—";

  const genres = ["All", ...new Set(ARTIST_TUNINGS.map(a => a.genre))];
  const artistSearchLower = artistSearch.toLowerCase();
  const filtered = ARTIST_TUNINGS
    .filter(a => filter === "All" || a.genre === filter)
    .filter(a => !artistSearchLower || a.name.toLowerCase().includes(artistSearchLower) || a.band.toLowerCase().includes(artistSearchLower));

  const navItems = [
    { id: "home",       icon: "⌂",  label: "Home" },
    { id: "calculator", icon: "◎",  label: "Calc" },
    { id: "match",      icon: "◈",  label: "Match" },
    { id: "build",      icon: "⊞",  label: "Build" },
    { id: "scanner",    icon: "▦",  label: "Strings" },
  ];

  // ── Shared SaveLoadPanel ──
  function SaveLoadPanel({ source }) {
    const stateMap = {
      calc:  { showing: showSaveInput,      setShowing: setShowSaveInput,      nameVal: saveNameInput,   setNameVal: setSaveNameInput   },
      match: { showing: showMatchSaveInput, setShowing: setShowMatchSaveInput, nameVal: matchSaveName,   setNameVal: setMatchSaveName   },
      build: { showing: showBuildSaveInput, setShowing: setShowBuildSaveInput, nameVal: buildSaveName,   setNameVal: setBuildSaveName   },
    };
    const { showing, setShowing, nameVal, setNameVal } = stateMap[source];
    return (
      <div style={{ marginBottom: 18 }}>
        {!showing ? (
          <button onClick={() => setShowing(true)} style={{ width: "100%", background: "#0f0f0f", border: "1px dashed #252525", borderRadius: 4, color: "#555", fontSize: 10, fontWeight: 700, letterSpacing: "0.2em", padding: "12px", cursor: "pointer", marginBottom: savedSetups.length ? 10 : 0 }}>+ SAVE THIS SETUP</button>
        ) : (
          <div style={{ display: "flex", gap: 8, marginBottom: 10 }}>
            <input autoFocus placeholder="Name this setup..." value={nameVal} onChange={e => setNameVal(e.target.value)}
              onKeyDown={e => { if (e.key === "Enter") { saveSetup(nameVal, source); setNameVal(""); setShowing(false); } }}
              style={{ flex: 1, background: "#0f0f0f", border: "1px solid #ff6b35", color: "#ddd8cc", padding: "10px 12px", borderRadius: 3, fontSize: 12 }} />
            <button onClick={() => { saveSetup(nameVal, source); setNameVal(""); setShowing(false); }} style={{ background: "#ff6b35", border: "none", borderRadius: 3, color: "#080808", fontSize: 11, fontWeight: 900, padding: "0 14px", cursor: "pointer" }}>SAVE</button>
            <button onClick={() => setShowing(false)} style={{ background: "#111", border: "1px solid #222", borderRadius: 3, color: "#555", fontSize: 11, padding: "0 10px", cursor: "pointer" }}>✕</button>
          </div>
        )}
        {savedSetups.length > 0 && (
          <div>
            <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 8 }}>
              <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#333" }}>SAVED SETUPS</div>
              <button onClick={() => setScreen("setups")} style={{ background: "none", border: "none", color: "#555", fontSize: 9, letterSpacing: "0.15em", cursor: "pointer", padding: 0, textDecoration: "underline" }}>MANAGE →</button>
            </div>
            <div style={{ display: "grid", gap: 6 }}>
              {savedSetups.map(setup => (
                <div key={setup.id} style={{ display: "flex", alignItems: "center", gap: 8, background: "#0a0a0a", border: "1px solid #1a1a1a", borderRadius: 3, padding: "10px 12px" }}>
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ fontSize: 12, fontWeight: 700, color: "#ddd8cc", overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{setup.name}</div>
                    <div style={{ fontSize: 9, color: "#333", marginTop: 2 }}>{setup.tuning} · {setup.scaleLength}" · {setup.gauges[0]}–{setup.gauges[setup.gauges.length-1]}</div>
                  </div>
                  <button onClick={() => { loadSetup(setup); setScreen(source === "match" ? "match" : source === "build" ? "build" : "calculator"); }} style={{ background: "#ff6b35", border: "none", borderRadius: 2, color: "#080808", fontSize: 9, fontWeight: 900, letterSpacing: "0.15em", padding: "6px 10px", cursor: "pointer", flexShrink: 0 }}>LOAD</button>
                  <button onClick={() => deleteSetup(setup.id)} style={{ background: "none", border: "none", color: "#333", fontSize: 14, cursor: "pointer", padding: "0 2px", flexShrink: 0 }}>✕</button>
                </div>
              ))}
            </div>
          </div>
        )}
      </div>
    );
  }

  // ── Shared StringRow ──
  function StringRow({ name, gauge, wound, tension, scale, onBumpUp, onBumpDown, onToggleWound, showScale }) {
    const pct = Math.min(100, ((tension || 0) / 35) * 100);
    const col  = tensionColor(tension);
    const lbl  = tensionLabel(tension);
    return (
      <div style={{ background: "#0f0f0f", border: "1px solid #181818", borderRadius: 4, padding: "10px 12px 8px", display: "flex", flexDirection: "column", gap: 7 }}>
        {/* Top row: string name · gauge controls · wound toggle · lbs readout */}
        <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
          {/* String name */}
          <div style={{ fontSize: 9, color: "#444", fontWeight: 700, width: 26, flexShrink: 0 }}>{name}</div>
          {/* − / gauge / + */}
          <button onClick={onBumpDown} style={{ background: "#181818", border: "1px solid #252525", borderRadius: 2, color: "#888", fontSize: 16, width: 28, height: 28, cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0, lineHeight: 1 }}>−</button>
          <div style={{ textAlign: "center", minWidth: 52, flexShrink: 0 }}>
            <div style={{ fontSize: 14, fontWeight: 900, color: "#ddd8cc", letterSpacing: "0.04em" }}>{gauge}</div>
            {showScale && <div style={{ fontSize: 8, color: "#333", marginTop: 1 }}>{typeof scale === "number" ? scale.toFixed(2)+'"' : ""}</div>}
          </div>
          <button onClick={onBumpUp} style={{ background: "#181818", border: "1px solid #252525", borderRadius: 2, color: "#888", fontSize: 16, width: 28, height: 28, cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0, lineHeight: 1 }}>+</button>
          {/* Wound toggle */}
          <button onClick={onToggleWound} style={{ background: wound ? "#1a1000" : "#0d0d18", border: `1px solid ${wound ? "#554400" : "#222244"}`, borderRadius: 2, color: wound ? "#aa7700" : "#5566aa", fontSize: 7, fontWeight: 900, letterSpacing: "0.08em", padding: "4px 3px", cursor: "pointer", width: 34, flexShrink: 0, textAlign: "center" }}>
            {wound ? "WND" : "PLN"}
          </button>
          {/* Tension lbs */}
          <div style={{ marginLeft: "auto", textAlign: "right", flexShrink: 0 }}>
            <div style={{ fontSize: 18, fontWeight: 900, color: col, lineHeight: 1 }}>{tension || "—"}</div>
            <div style={{ fontSize: 7, color: "#444", letterSpacing: "0.12em", marginTop: 2 }}>{lbl}</div>
          </div>
        </div>
        {/* Bar — full width, chunky */}
        <div style={{ position: "relative", height: 10, background: "#141414", borderRadius: 5, overflow: "hidden" }}>
          <div style={{
            position: "absolute", left: 0, top: 0, bottom: 0,
            width: `${pct}%`,
            background: `linear-gradient(90deg, ${col}88, ${col})`,
            borderRadius: 5,
            boxShadow: tension ? `0 0 8px ${col}55` : "none",
            transition: "width 0.35s cubic-bezier(0.4,0,0.2,1)"
          }} />
          {/* Tick marks at 25% / 50% / 75% */}
          {[25,50,75].map(t => (
            <div key={t} style={{ position: "absolute", top: 2, bottom: 2, left: `${t}%`, width: 1, background: "#0f0f0f44", borderRadius: 1 }} />
          ))}
        </div>
      </div>
    );
  }

  // ── Selectable pill button ──
  const Pill = ({ active, onClick, children, color = "#ff6b35" }) => (
    <button onClick={onClick} style={{ background: active ? color : "#111", border: `1px solid ${active ? color : "#252525"}`, borderRadius: 20, color: active ? "#080808" : "#555", fontSize: 10, fontWeight: 700, letterSpacing: "0.15em", padding: "7px 16px", cursor: "pointer", whiteSpace: "nowrap", transition: "all 0.15s" }}>{children}</button>
  );

  const scaleOptions = buildInstrument === "bass" ? BASS_SCALES : GUITAR_SCALES;

  // ── MultiScalePanel: per-string scale length entry ──────────────────────
  // stringScales: number[] (one per string, high→low)
  // onStringScaleChange: (index, value) => void
  function MultiScalePanel({ enabled, onToggle, singleScale, onSingleChange, stringScales, onStringScaleChange, numStrings = 6, accentColor = "#ff6b35", instrument = "guitar" }) {
    const nameMap = instrument === "bass" ? BASS_STRING_NAMES : GUITAR_STRING_NAMES;
    const names = nameMap[numStrings] || GUITAR_STRING_NAMES[6];
    const SCALE_OPTIONS = instrument === "bass"
      ? [30.0, 30.5, 31.0, 31.5, 32.0, 32.5, 33.0, 33.25, 34.0, 34.5, 35.0, 35.5, 36.0]
      : [24.0, 24.625, 24.75, 25.0, 25.5, 26.0, 26.5, 27.0, 27.5, 28.0, 28.5, 29.0, 29.5, 30.0, 30.5, 31.0, 31.5, 32.0];
    return (
      <div style={{ marginBottom: 16 }}>
        {/* Single-scale row + toggle */}
        <div style={{ display: "flex", alignItems: "flex-end", gap: 10, marginBottom: enabled ? 12 : 0 }}>
          {!enabled && (
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#444", marginBottom: 6 }}>SCALE LENGTH</div>
              <select value={singleScale} onChange={e => onSingleChange(parseFloat(e.target.value))}
                style={{ width: "100%", background: "#111", border: "1px solid #252525", color: "#ddd8cc", padding: "9px 10px", borderRadius: 3, fontSize: 13 }}>
                {SCALE_OPTIONS.map(s => <option key={s} value={s}>{s}"</option>)}
              </select>
            </div>
          )}
          {enabled && <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#444", flex: 1, paddingBottom: 4 }}>SCALE PER STRING</div>}
          <button onClick={onToggle}
            style={{ background: enabled ? "#0d160d" : "#111", border: `1px solid ${enabled ? accentColor : "#333"}`, borderRadius: 20, padding: "6px 14px", cursor: "pointer", color: enabled ? accentColor : "#444", fontSize: 9, fontWeight: 900, letterSpacing: "0.12em", transition: "all 0.15s", flexShrink: 0, marginBottom: 0 }}>
            {enabled ? "MULTI-SCALE ●" : "MULTI-SCALE ○"}
          </button>
        </div>
        {/* Per-string inputs */}
        {enabled && (
          <div style={{ background: "#0a0a0a", border: "1px solid #1a1a1a", borderRadius: 4, padding: "10px 12px", display: "grid", gap: 6 }}>
            {names.map((name, i) => (
              <div key={i} style={{ display: "flex", alignItems: "center", gap: 8 }}>
                <div style={{ fontSize: 9, color: "#555", fontWeight: 700, width: 26, flexShrink: 0 }}>{name}</div>
                <select
                  value={stringScales[i] ?? 25.5}
                  onChange={e => onStringScaleChange(i, parseFloat(e.target.value))}
                  style={{ flex: 1, background: "#111", border: "1px solid #252525", color: "#ddd8cc", padding: "7px 8px", borderRadius: 3, fontSize: 12 }}>
                  {SCALE_OPTIONS.map(s => <option key={s} value={s}>{s}"</option>)}
                </select>
                <div style={{ width: 32, height: 6, background: "#1a1a1a", borderRadius: 3, flexShrink: 0 }}>
                  <div style={{ height: "100%", width: `${Math.min(100, Math.max(4, ((stringScales[i] ?? 25.5) - 24.0) / (32.0 - 24.0) * 100))}%`, background: accentColor, borderRadius: 3, opacity: 0.8 }} />
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    );
  }

  // ── BuyPanel: smart affiliate retailer links ──
  function BuyPanel({ gauges: g, woundArr, packName, onBuy }) {
    const targetGauges = g.map((v, i) => v + (woundArr && woundArr[i] ? "w" : ""));
    // Find closest matching packs
    const type = woundArr && woundArr.slice(3).some(w => w) ? "electric" : "electric";
    const matches = STRING_PACKS
      .filter(p => p.gauges.length === g.length)
      .map(p => ({ pack: p, score: scorePackMatch(p.gauges, targetGauges) }))
      .sort((a, b) => a.score - b.score)
      .slice(0, 3);
    const firstNum = Math.round(parseFloat(g[0]) * 1000);
    const lastNum  = Math.round(parseFloat(g[g.length - 1]) * 1000);
    const searchTerm = packName || `electric guitar strings ${firstNum}-${lastNum}`;
    return (
      <div style={{ background: "#0f0f0f", border: "1px solid #1e1e1e", borderRadius: 4, padding: "16px", marginBottom: 10 }}>
        {matches.length > 0 && matches[0].score < 0.015 && (
          <div style={{ marginBottom: 14 }}>
            <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#444", marginBottom: 8 }}>CLOSEST MATCHING PACKS</div>
            {matches.map(({ pack, score }) => (
              <div key={pack.id} style={{ display: "flex", alignItems: "center", gap: 10, background: "#0a0a0a", border: "1px solid #1a1a1a", borderRadius: 3, padding: "9px 12px", marginBottom: 6 }}>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ fontSize: 11, fontWeight: 700, color: "#ddd8cc" }}>{pack.brand} {pack.name}</div>
                  <div style={{ fontSize: 9, color: "#444", marginTop: 2 }}>{pack.gauges.join(" · ")} {score < 0.001 ? "· exact match" : `· ~${(score * 1000).toFixed(0)}% off`}</div>
                </div>
                {score < 0.001 && <div style={{ fontSize: 8, color: "#60d080", border: "1px solid #1a4020", borderRadius: 2, padding: "2px 6px", letterSpacing: "0.15em", flexShrink: 0 }}>EXACT</div>}
              </div>
            ))}
          </div>
        )}
        <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#444", marginBottom: 10 }}>BUY THIS SET</div>
        {onBuy ? (
          <button onClick={() => onBuy(g, woundArr || [], packName || searchTerm)} style={{ width: "100%", background: "#ff6b35", border: "none", borderRadius: 4, color: "#080808", fontSize: 12, fontWeight: 900, letterSpacing: "0.2em", padding: "14px", cursor: "pointer" }}>
            SHOP FOR STRINGS →
          </button>
        ) : (
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 8 }}>
            {RETAILERS.map(r => (
              <a key={r.name} href={r.buildUrl(searchTerm)} target="_blank" rel="noopener noreferrer" style={{ background: "#111", border: "1px solid #252525", borderRadius: 3, color: r.color, fontSize: 11, fontWeight: 700, padding: "11px 8px", cursor: "pointer", textDecoration: "none", display: "flex", alignItems: "center", justifyContent: "center", gap: 5 }}>
                <span>{r.icon}</span> {r.name} →
              </a>
            ))}
          </div>
        )}
      </div>
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  return (
    <div style={{ fontFamily: "'Courier New', monospace", background: "#080808", minHeight: "100vh", color: "#ddd8cc", maxWidth: 430, margin: "0 auto", position: "relative" }}>
      <style>{`
        * { box-sizing: border-box; }
        button { font-family: 'Courier New', monospace; }
        input, select { font-family: 'Courier New', monospace; }
        select option { background: #111; }
        @keyframes scanline { 0% { top: 18%; opacity: 1; } 100% { top: 82%; opacity: 0.2; } }
        @keyframes fadein { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: translateY(0); } }
        .fadein { animation: fadein 0.35s ease forwards; }
        ::-webkit-scrollbar { width: 0; }
      `}</style>

      {/* ── HEADER ── */}
      <div style={{ position: "sticky", top: 0, zIndex: 100, background: "linear-gradient(180deg, #080808 75%, transparent)", padding: "18px 20px 10px", borderBottom: "1px solid #181818" }}>
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
          {!["home","calculator","build","match","scanner","artists","diagnostics","setups"].includes(screen) ? (
            <button onClick={() => setScreen("home")} style={{ background: "none", border: "none", color: "#666", cursor: "pointer", fontSize: 20, padding: 0 }}>←</button>
          ) : <div style={{ width: 24 }} />}
          <div style={{ textAlign: "center" }}>
            <div style={{ fontSize: 24, fontWeight: 900, letterSpacing: "0.18em", color: "#ddd8cc", textShadow: "0 0 40px rgba(255,107,53,0.25)" }}>DOWNTUNE</div>
            <div style={{ fontSize: 8, letterSpacing: "0.45em", color: "#444", marginTop: -1 }}>STRING TENSION CALCULATOR</div>
          </div>
          <div style={{ width: 24 }} />
        </div>
      </div>

      <div style={{ padding: "0 0 90px", opacity: loaded ? 1 : 0, transition: "opacity 0.4s" }}>

        {/* ══ HOME ══════════════════════════════════════════════════════════════ */}
        {screen === "home" && (
          <div className="fadein">
            <div style={{ padding: "28px 20px 20px", textAlign: "center" }}>
              <div style={{ fontSize: 12, letterSpacing: "0.35em", color: "#ff6b35", marginBottom: 8 }}>LESS THAN TWO PACKS OF STRINGS</div>
              <div style={{ fontSize: 14, color: "#555", lineHeight: 1.7 }}>Never buy the wrong strings again.</div>
            </div>
            <div style={{ padding: "0 20px", display: "grid", gap: 10 }}>
              <button onClick={() => setScreen("calculator")} style={{ background: "linear-gradient(135deg, #180d00, #241200)", border: "1px solid #ff6b35", borderRadius: 4, padding: "22px", cursor: "pointer", textAlign: "left" }}>
                <div style={{ fontSize: 10, letterSpacing: "0.35em", color: "#ff6b35", marginBottom: 6 }}>CALCULATE</div>
                <div style={{ fontSize: 18, fontWeight: 800, color: "#ddd8cc" }}>Tension Calculator</div>
                <div style={{ fontSize: 12, color: "#555", marginTop: 4 }}>Enter gauges, tuning &amp; scale length</div>
              </button>
              <button onClick={() => setScreen("match")} style={{ background: "linear-gradient(135deg, #0e1a12, #0a1a14)", border: "1px solid #7fffd4", borderRadius: 4, padding: "22px", cursor: "pointer", textAlign: "left" }}>
                <div style={{ fontSize: 10, letterSpacing: "0.35em", color: "#7fffd4", marginBottom: 6 }}>FEEL-BASED</div>
                <div style={{ fontSize: 18, fontWeight: 800, color: "#ddd8cc" }}>Match My Feel</div>
                <div style={{ fontSize: 12, color: "#555", marginTop: 4 }}>Describe how strings should feel → get gauges</div>
              </button>
              <button onClick={() => setScreen("build")} style={{ background: "linear-gradient(135deg, #0d1a10, #0a1812)", border: "1px solid #60d080", borderRadius: 4, padding: "22px", cursor: "pointer", textAlign: "left" }}>
                <div style={{ fontSize: 10, letterSpacing: "0.35em", color: "#60d080", marginBottom: 6 }}>NEW</div>
                <div style={{ fontSize: 18, fontWeight: 800, color: "#ddd8cc" }}>Build A Setup</div>
                <div style={{ fontSize: 12, color: "#555", marginTop: 4 }}>Guitar or bass · multi-scale · auto-calculated gauges</div>
              </button>
              <button onClick={() => setScreen("artists")} style={{ background: "linear-gradient(135deg, #0e0e1c, #141428)", border: "1px solid #5555aa", borderRadius: 4, padding: "22px", cursor: "pointer", textAlign: "left" }}>
                <div style={{ fontSize: 10, letterSpacing: "0.35em", color: "#8888ee", marginBottom: 6 }}>ARTIST TUNINGS</div>
                <div style={{ fontSize: 18, fontWeight: 800, color: "#ddd8cc" }}>Load a Legend&apos;s Setup</div>
                <div style={{ fontSize: 12, color: "#555", marginTop: 4 }}>Iommi · Matt Pike · Windstein · Wino</div>
              </button>
              <button onClick={() => setScreen("setups")} style={{ background: "#0f0f0f", border: "1px solid #333", borderRadius: 4, padding: "22px", cursor: "pointer", textAlign: "left", display: "flex", alignItems: "center", justifyContent: "space-between" }}>
                <div>
                  <div style={{ fontSize: 10, letterSpacing: "0.35em", color: "#666", marginBottom: 6 }}>SAVED</div>
                  <div style={{ fontSize: 18, fontWeight: 800, color: "#ddd8cc" }}>My Setups</div>
                  <div style={{ fontSize: 12, color: "#555", marginTop: 4 }}>Load, rename, delete your saved setups</div>
                </div>
                <div style={{ fontSize: 28, color: "#333", marginLeft: 16 }}>{savedSetups.length > 0 ? <span style={{ fontSize: 22, fontWeight: 900, color: "#ff6b35" }}>{savedSetups.length}</span> : "○"}</div>
              </button>
            </div>
          </div>
        )}

        {/* ══ CALCULATOR ════════════════════════════════════════════════════════ */}
        {screen === "calculator" && (
          <div className="fadein" style={{ padding: "20px" }}>
            <div style={{ fontSize: 10, letterSpacing: "0.35em", color: "#ff6b35", marginBottom: 20 }}>TENSION CALCULATOR</div>

            {/* ── Instrument + String Count ── */}
            <div style={{ display: "flex", gap: 8, marginBottom: 14 }}>
              {[["guitar","GUITAR"],["bass","BASS"]].map(([inst, lbl]) => (
                <button key={inst} onClick={() => changeCalcInstrument(inst)} style={{ flex: 1, background: calcInstrument === inst ? "#1a0d00" : "#0f0f0f", border: `2px solid ${calcInstrument === inst ? "#ff6b35" : "#252525"}`, borderRadius: 4, color: calcInstrument === inst ? "#ff6b35" : "#444", fontSize: 11, fontWeight: 900, letterSpacing: "0.12em", padding: "10px", cursor: "pointer" }}>{lbl}</button>
              ))}
            </div>
            <div style={{ marginBottom: 16 }}>
              <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#444", marginBottom: 7 }}>STRINGS</div>
              <div style={{ display: "flex", gap: 6 }}>
                {(calcInstrument === "bass" ? [4,5,6] : [6,7,8]).map(n => (
                  <button key={n} onClick={() => changeCalcCount(n)} style={{ flex: 1, background: calcStringCount === n ? "#1a0d00" : "#0f0f0f", border: `1px solid ${calcStringCount === n ? "#ff6b35" : "#252525"}`, borderRadius: 3, color: calcStringCount === n ? "#ff6b35" : "#444", fontSize: 12, fontWeight: 900, padding: "9px", cursor: "pointer" }}>{n}</button>
                ))}
              </div>
            </div>

            <div style={{ display: "flex", alignItems: "flex-end", gap: 12, marginBottom: 16 }}>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#444", marginBottom: 7 }}>TUNING</div>
                <select value={tuning} onChange={e => setTuning(e.target.value)} style={{ width: "100%", background: "#111", border: "1px solid #252525", color: "#ddd8cc", padding: "11px 10px", borderRadius: 3, fontSize: 13 }}>
                  {TUNING_GROUPS.map(grp => (
                    <optgroup key={grp} label={grp}>
                      {TUNING_LIST.filter(t => t.group === grp).map(t => (
                        <option key={t.id} value={t.id}>{t.label}</option>
                      ))}
                    </optgroup>
                  ))}
                </select>
              </div>
            </div>
            <MultiScalePanel
              enabled={calcMultiScale} onToggle={() => setCalcMultiScale(v => !v)}
              singleScale={scaleLength} onSingleChange={setScaleLength}
              stringScales={calcStringScales}
              onStringScaleChange={(i, v) => { const a = [...calcStringScales]; a[i] = v; setCalcStringScales(a); }}
              numStrings={calcStringCount} instrument={calcInstrument}
              accentColor="#ff6b35"
            />
            <StringTypeSelector value={stringType} onChange={setStringType} accentColor="#ff6b35" />
            <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#444", marginBottom: 4 }}>STRING GAUGES</div>
            <div style={{ fontSize: 8, color: "#333", marginBottom: 10, letterSpacing: "0.1em" }}>+/− to bump gauge · WND/PLN to toggle wound</div>
            <div style={{ display: "grid", gap: 6, marginBottom: 22 }}>
              {getStringNames(calcInstrument, calcStringCount, tuning).map((name, i) => {
                const perStringScale = calcMultiScale ? (calcStringScales[i] ?? scaleLength) : null;
                return (
                  <StringRow key={i} name={name} gauge={gauges[i]} wound={woundFlags[i]} tension={tensions[i]}
                    scale={perStringScale} showScale={calcMultiScale}
                    onBumpUp={() => bump(i, 1)} onBumpDown={() => bump(i, -1)} onToggleWound={() => toggleWound(i)} />
                );
              })}
            </div>
            <div style={{ background: "#0f0f0f", border: "1px solid #1e1e1e", borderRadius: 4, padding: "16px 20px", marginBottom: 14, display: "flex", justifyContent: "space-between" }}>
              <div>
                <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#444" }}>AVG TENSION</div>
                <div style={{ fontSize: 32, fontWeight: 900, color: "#ff6b35", marginTop: 3 }}>{avgTension}<span style={{ fontSize: 12, color: "#444", marginLeft: 4 }}>lbs</span></div>
              </div>
              <div style={{ textAlign: "right" }}>
                <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#444" }}>TOTAL PULL</div>
                <div style={{ fontSize: 32, fontWeight: 900, color: "#ddd8cc", marginTop: 3 }}>{totalTension}<span style={{ fontSize: 12, color: "#444", marginLeft: 4 }}>lbs</span></div>
              </div>
            </div>
            <button onClick={generateSet} style={{ width: "100%", background: "#ff6b35", border: "none", borderRadius: 4, color: "#080808", fontSize: 12, fontWeight: 900, letterSpacing: "0.22em", padding: "16px", cursor: "pointer", marginBottom: 10 }}>GENERATE STRING SET →</button>
            <button onClick={() => { setBuyGauges(gauges); setBuyWound(woundFlags); setBuyPackName(""); setScreen("buy"); }} style={{ width: "100%", background: "#111", border: "1px solid #ff6b35", borderRadius: 4, color: "#ff6b35", fontSize: 12, fontWeight: 700, letterSpacing: "0.18em", padding: "14px", cursor: "pointer", marginBottom: 18 }}>SHOP THIS SETUP →</button>
            <SaveLoadPanel source="calc" />
          </div>
        )}

        {/* ══ BUILD A SETUP ═════════════════════════════════════════════════════ */}
        {screen === "build" && (
          <div className="fadein" style={{ padding: "20px" }}>
            <div style={{ fontSize: 10, letterSpacing: "0.35em", color: "#60d080", marginBottom: 6 }}>BUILD A SETUP</div>
            <div style={{ fontSize: 13, color: "#555", marginBottom: 22, lineHeight: 1.7 }}>Configure your instrument and we&apos;ll calculate the perfect gauges.</div>
            <StringTypeSelector value={stringType} onChange={setStringType} accentColor="#60d080" />
            {/* ── Guitar / Bass toggle ── */}
            <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#444", marginBottom: 10 }}>INSTRUMENT</div>
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 8, marginBottom: 20 }}>
              {[["guitar","GUITAR 🎸"],["bass","BASS 🎸"]].map(([val, label]) => (
                <button key={val} onClick={() => { setBuildInstrument(val); setBuildStringCount(val === "bass" ? 4 : 6); setBuildResult(null); }} style={{ background: buildInstrument === val ? "#0d1a10" : "#0f0f0f", border: `2px solid ${buildInstrument === val ? "#60d080" : "#252525"}`, borderRadius: 4, color: buildInstrument === val ? "#60d080" : "#444", fontSize: 12, fontWeight: 900, letterSpacing: "0.12em", padding: "14px", cursor: "pointer", transition: "all 0.15s" }}>
                  {label}
                </button>
              ))}
            </div>

            {/* ── String count ── */}
            <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#444", marginBottom: 10 }}>NUMBER OF STRINGS</div>
            <div style={{ display: "flex", gap: 8, marginBottom: 20 }}>
              {(buildInstrument === "bass" ? [4, 5, 6] : [6, 7, 8]).map(n => (
                <Pill key={n} active={buildStringCount === n} color="#60d080" onClick={() => { setBuildStringCount(n); setBuildResult(null); }}>{n}-STRING</Pill>
              ))}
            </div>

            {/* ── Tuning ── */}
            <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#444", marginBottom: 7 }}>TUNING</div>
            <select value={buildTuning} onChange={e => { setBuildTuning(e.target.value); setBuildResult(null); }} style={{ width: "100%", background: "#111", border: "1px solid #252525", color: "#ddd8cc", padding: "11px 10px", borderRadius: 3, fontSize: 13, marginBottom: 20 }}>
              {TUNING_GROUPS.map(grp => (
                <optgroup key={grp} label={grp}>
                  {TUNING_LIST.filter(t => t.group === grp).map(t => (
                    <option key={t.id} value={t.id}>{t.label}</option>
                  ))}
                </optgroup>
              ))}
            </select>

            {/* ── Multi-scale toggle ── */}
            <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 14 }}>
              <div>
                <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#444" }}>MULTI-SCALE</div>
                <div style={{ fontSize: 10, color: "#333", marginTop: 3 }}>Fan fret / fanned fret instrument</div>
              </div>
              <button onClick={() => { setBuildMultiScale(v => !v); setBuildResult(null); }} style={{ background: buildMultiScale ? "#0d1a10" : "#111", border: `2px solid ${buildMultiScale ? "#60d080" : "#333"}`, borderRadius: 20, padding: "6px 16px", cursor: "pointer", color: buildMultiScale ? "#60d080" : "#444", fontSize: 10, fontWeight: 900, letterSpacing: "0.1em", transition: "all 0.15s", minWidth: 60 }}>
                {buildMultiScale ? "ON" : "OFF"}
              </button>
            </div>

            {/* ── Scale length ── */}
            {!buildMultiScale ? (
              <div style={{ marginBottom: 20 }}>
                <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#444", marginBottom: 7 }}>SCALE LENGTH</div>
                <select value={buildSingleScale} onChange={e => { setBuildSingleScale(parseFloat(e.target.value)); setBuildResult(null); }} style={{ width: "100%", background: "#111", border: "1px solid #252525", color: "#ddd8cc", padding: "11px 10px", borderRadius: 3, fontSize: 14 }}>
                  {scaleOptions.map(s => <option key={s} value={s}>{s}"</option>)}
                </select>
              </div>
            ) : (
              <div style={{ marginBottom: 20 }}>
                {/* Per-string scale inputs */}
                <div style={{ marginTop: 12, background: "#0a0a0a", border: "1px solid #1a1a1a", borderRadius: 4, padding: "10px 12px" }}>
                  <div style={{ fontSize: 8, color: "#333", letterSpacing: "0.2em", marginBottom: 8 }}>SCALE LENGTH PER STRING</div>
                  <div style={{ display: "grid", gap: 6 }}>
                    {(buildInstrument === "bass" ? BASS_STRING_NAMES[buildStringCount] : GUITAR_STRING_NAMES[buildStringCount]).map((name, i) => {
                      const SOPTS = [24.0, 24.625, 24.75, 25.0, 25.5, 25.625, 26.0, 26.5, 27.0, 27.5, 28.0];
                      return (
                        <div key={i} style={{ display: "flex", alignItems: "center", gap: 8 }}>
                          <div style={{ fontSize: 9, color: "#555", fontWeight: 700, width: 28, flexShrink: 0 }}>{name}</div>
                          <select
                            value={buildStringScales[i] ?? 25.5}
                            onChange={e => { const a = [...buildStringScales]; a[i] = parseFloat(e.target.value); setBuildStringScales(a); setBuildResult(null); }}
                            style={{ flex: 1, background: "#111", border: "1px solid #252525", color: "#ddd8cc", padding: "7px 8px", borderRadius: 3, fontSize: 12 }}>
                            {SOPTS.map(s => <option key={s} value={s}>{s}"</option>)}
                          </select>
                          <div style={{ width: 32, height: 6, background: "#181818", borderRadius: 3, flexShrink: 0 }}>
                            <div style={{ height: "100%", width: `${Math.min(100, Math.max(4, ((buildStringScales[i] ?? 25.5) - 24.0) / (32.0 - 24.0) * 100))}%`, background: "#60d080", borderRadius: 3, opacity: 0.8 }} />
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </div>
              </div>
            )}

            {/* ── Feel selector ── */}
            <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#444", marginBottom: 10 }}>TARGET FEEL</div>
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: 8, marginBottom: 22 }}>
              {BUILD_FEELS.map(feel => (
                <button key={feel.id} onClick={() => { setBuildFeel(feel); setBuildResult(null); }} style={{ background: buildFeel?.id === feel.id ? "#0d1a10" : "#0f0f0f", border: `2px solid ${buildFeel?.id === feel.id ? feel.color : "#1a1a1a"}`, borderRadius: 4, padding: "14px 8px", cursor: "pointer", textAlign: "center", transition: "all 0.15s" }}>
                  <div style={{ fontSize: 20, marginBottom: 6, color: buildFeel?.id === feel.id ? feel.color : "#333" }}>{feel.icon}</div>
                  <div style={{ fontSize: 11, fontWeight: 800, color: buildFeel?.id === feel.id ? "#ddd8cc" : "#555" }}>{feel.label}</div>
                  <div style={{ fontSize: 8, color: "#333", marginTop: 3, lineHeight: 1.4 }}>{feel.desc}</div>
                </button>
              ))}
            </div>

            <button onClick={generateBuild} disabled={!buildFeel} style={{ width: "100%", background: buildFeel ? "#60d080" : "#111", border: buildFeel ? "none" : "1px solid #222", borderRadius: 4, color: buildFeel ? "#080808" : "#333", fontSize: 12, fontWeight: 900, letterSpacing: "0.2em", padding: "16px", cursor: buildFeel ? "pointer" : "not-allowed", marginBottom: 22, transition: "all 0.3s" }}>
              {buildFeel ? `BUILD ${buildInstrument.toUpperCase()} SETUP →` : "SELECT A TARGET FEEL FIRST"}
            </button>

            {/* ── Build Result ── */}
            {buildResult && (
              <div style={{ marginBottom: 18 }}>
                <div style={{ background: "#0d1a10", border: "1px solid #1a3020", borderRadius: 4, padding: "14px 16px", marginBottom: 14 }}>
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: 12 }}>
                    <div>
                      <div style={{ fontSize: 8, letterSpacing: "0.3em", color: "#60d080", marginBottom: 2 }}>GENERATED SETUP</div>
                      <div style={{ fontSize: 13, fontWeight: 800, color: "#ddd8cc" }}>
                        {buildStringCount}-String {buildInstrument === "bass" ? "Bass" : "Guitar"} · {buildTuning} Std
                      </div>
                      <div style={{ fontSize: 10, color: "#444", marginTop: 2 }}>
                        {buildMultiScale ? "multi-scale" : `${buildSingleScale}" scale`} · {buildFeel?.label}
                      </div>
                    </div>
                    <div style={{ fontSize: 8, background: "#1a3020", border: "1px solid #2a5030", borderRadius: 2, padding: "4px 8px", color: "#60d080", letterSpacing: "0.15em" }}>
                      {buildFeel?.label.toUpperCase()}
                    </div>
                  </div>
                  <div style={{ display: "grid", gap: 5 }}>
                    {buildResult.stringNames.map((name, i) => (
                      <div key={i} style={{ display: "grid", gridTemplateColumns: "28px 60px 32px 1fr 64px", alignItems: "center", gap: 8, background: "#0a1410", borderRadius: 3, padding: "8px 10px" }}>
                        <div style={{ fontSize: 9, color: "#3a3a3a", fontWeight: 700 }}>{name}</div>
                        <div style={{ fontSize: 13, fontWeight: 800, color: "#60d080" }}>{buildResult.gauges[i]}</div>
                        <div style={{ fontSize: 7, fontWeight: 900, color: buildResult.wounds[i] ? "#aa7700" : "#5566aa", background: buildResult.wounds[i] ? "#1a1000" : "#0d0d18", border: `1px solid ${buildResult.wounds[i] ? "#554400" : "#222244"}`, borderRadius: 2, padding: "2px 3px", textAlign: "center" }}>
                          {buildResult.wounds[i] ? "WND" : "PLN"}
                        </div>
                        <div style={{ height: 3, background: "#1a2a20", borderRadius: 2, overflow: "hidden" }}>
                          <div style={{ height: "100%", width: `${Math.min(100, (buildResult.tensions[i]||0) / 35 * 100)}%`, background: tensionColor(buildResult.tensions[i]), borderRadius: 2 }} />
                        </div>
                        <div style={{ textAlign: "right" }}>
                          <div style={{ fontSize: 12, fontWeight: 800, color: tensionColor(buildResult.tensions[i]) }}>{buildResult.tensions[i] || "—"}</div>
                          {buildMultiScale && <div style={{ fontSize: 7, color: "#333" }}>{buildResult.scales[i].toFixed(2)}"</div>}
                        </div>
                      </div>
                    ))}
                  </div>
                  <div style={{ borderTop: "1px solid #1a3020", marginTop: 12, paddingTop: 10, display: "flex", justifyContent: "space-between" }}>
                    <div style={{ fontSize: 10, color: "#444" }}>AVG {(buildResult.tensions.reduce((a, b) => a + b, 0) / buildResult.tensions.length).toFixed(1)} lbs</div>
                    <div style={{ fontSize: 10, color: "#444" }}>TOTAL {buildResult.tensions.reduce((a, b) => a + b, 0).toFixed(0)} lbs</div>
                  </div>
                </div>
                <button onClick={generateSetFromBuild} style={{ width: "100%", background: "#60d080", border: "none", borderRadius: 4, color: "#080808", fontSize: 12, fontWeight: 900, letterSpacing: "0.22em", padding: "16px", cursor: "pointer", marginBottom: 10 }}>GENERATE STRING SET →</button>
                <button onClick={() => { setBuyGauges(buildResult.gauges); setBuyWound(buildResult.wounds); setBuyPackName(""); setScreen("buy"); }} style={{ width: "100%", background: "#111", border: "1px solid #60d080", borderRadius: 4, color: "#60d080", fontSize: 12, fontWeight: 700, letterSpacing: "0.18em", padding: "14px", cursor: "pointer", marginBottom: 10 }}>SHOP THIS SETUP →</button>
                <button onClick={() => {
                  setGauges(buildResult.gauges);
                  setWoundFlags(buildResult.wounds);
                  if (!buildMultiScale) setScaleLength(buildSingleScale);
                  setTuning(buildTuning);
                  setScreen("calculator");
                }} style={{ width: "100%", background: "#111", border: "1px solid #ff6b35", borderRadius: 4, color: "#ff6b35", fontSize: 11, fontWeight: 700, letterSpacing: "0.15em", padding: "13px", cursor: "pointer", marginBottom: 10 }}>
                  EDIT IN CALCULATOR →
                </button>
                <SaveLoadPanel source="build" />
              </div>
            )}
          </div>
        )}

        {/* ══ MATCH MY FEEL ═════════════════════════════════════════════════════ */}
        {screen === "match" && (
          <div className="fadein" style={{ padding: "20px" }}>
            <div style={{ fontSize: 10, letterSpacing: "0.35em", color: "#7fffd4", marginBottom: 6 }}>MATCH MY FEEL</div>
            <div style={{ fontSize: 13, color: "#555", marginBottom: 22, lineHeight: 1.7 }}>
              Enter your current setup to calculate its tension, then pick a new tuning and scale — we&apos;ll find the gauges that match that exact feel.
            </div>

            <StringTypeSelector value={stringType} onChange={setStringType} accentColor="#7fffd4" />
            {/* ── STEP 1: Source setup ── */}
            <div style={{ background: "#0a0f0a", border: "1px solid #1a2a1a", borderRadius: 4, padding: "16px", marginBottom: 16 }}>
              <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 14 }}>
                <div>
                  <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#7fffd4" }}>STEP 1 — YOUR CURRENT SETUP</div>
                  <div style={{ fontSize: 10, color: "#333", marginTop: 3 }}>The setup whose feel you want to match</div>
                </div>
                <button onClick={() => { setSrcInstrument(calcInstrument); setSrcStringCount(calcStringCount); setSrcGauges([...gauges]); setSrcWound([...woundFlags]); setSrcScale(scaleLength); setSrcTuning(tuning); setMatchGenerated(false); }} style={{ background: "#111", border: "1px solid #7fffd4", borderRadius: 3, color: "#7fffd4", fontSize: 9, fontWeight: 900, letterSpacing: "0.12em", padding: "6px 10px", cursor: "pointer", flexShrink: 0 }}>LOAD FROM CALC</button>
              </div>

              {/* Instrument + String Count */}
              <div style={{ display: "flex", gap: 6, marginBottom: 10 }}>
                {[["guitar","GUITAR"],["bass","BASS"]].map(([inst, lbl]) => (
                  <button key={inst} onClick={() => changeSrcInstrument(inst)} style={{ flex: 1, background: srcInstrument === inst ? "#0a1a0a" : "#0a0a0a", border: `1px solid ${srcInstrument === inst ? "#7fffd4" : "#1e1e1e"}`, borderRadius: 3, color: srcInstrument === inst ? "#7fffd4" : "#444", fontSize: 10, fontWeight: 900, letterSpacing: "0.1em", padding: "8px", cursor: "pointer" }}>{lbl}</button>
                ))}
              </div>
              <div style={{ marginBottom: 10 }}>
                <div style={{ fontSize: 8, letterSpacing: "0.3em", color: "#444", marginBottom: 6 }}>STRINGS</div>
                <div style={{ display: "flex", gap: 5 }}>
                  {(srcInstrument === "bass" ? [4,5,6] : [6,7,8]).map(n => (
                    <button key={n} onClick={() => changeSrcCount(n)} style={{ flex: 1, background: srcStringCount === n ? "#0a1a0a" : "#0a0a0a", border: `1px solid ${srcStringCount === n ? "#7fffd4" : "#1e1e1e"}`, borderRadius: 3, color: srcStringCount === n ? "#7fffd4" : "#444", fontSize: 11, fontWeight: 900, padding: "7px", cursor: "pointer" }}>{n}</button>
                  ))}
                </div>
              </div>

              <div style={{ marginBottom: 12 }}>
                <div style={{ fontSize: 8, letterSpacing: "0.3em", color: "#444", marginBottom: 6 }}>TUNING</div>
                <select value={srcTuning} onChange={e => { setSrcTuning(e.target.value); setMatchGenerated(false); }} style={{ width: "100%", background: "#111", border: "1px solid #252525", color: "#ddd8cc", padding: "9px 8px", borderRadius: 3, fontSize: 12 }}>
                  {TUNING_GROUPS.map(grp => (
                    <optgroup key={grp} label={grp}>
                      {TUNING_LIST.filter(t => t.group === grp).map(t => (
                        <option key={t.id} value={t.id}>{t.label}</option>
                      ))}
                    </optgroup>
                  ))}
                </select>
              </div>
              <MultiScalePanel
                enabled={srcMultiScale} onToggle={() => { setSrcMultiScale(v => !v); setMatchGenerated(false); }}
                singleScale={srcScale} onSingleChange={v => { setSrcScale(v); setMatchGenerated(false); }}
                stringScales={srcStringScales}
                onStringScaleChange={(i, v) => { const a = [...srcStringScales]; a[i] = v; setSrcStringScales(a); setMatchGenerated(false); }}
                numStrings={srcStringCount} instrument={srcInstrument}
                accentColor="#7fffd4"
              />

              <div style={{ fontSize: 8, color: "#333", marginBottom: 8, letterSpacing: "0.1em" }}>GAUGES — +/− to adjust · WND/PLN to toggle</div>
              <div style={{ display: "grid", gap: 5, marginBottom: 12 }}>
                {getStringNames(srcInstrument, srcStringCount, srcTuning).map((name, i) => {
                  const ps = srcMultiScale ? (srcStringScales[i] ?? srcScale) : null;
                  return (
                    <StringRow key={i} name={name} gauge={srcGauges[i]} wound={srcWound[i]} tension={srcTensions[i]}
                      scale={ps} showScale={srcMultiScale}
                      onBumpUp={() => bumpSrc(i, 1)} onBumpDown={() => bumpSrc(i, -1)} onToggleWound={() => toggleSrcWound(i)} />
                  );
                })}
              </div>

              <div style={{ background: "#070f07", border: "1px solid #1a2a1a", borderRadius: 3, padding: "10px 14px", display: "flex", justifyContent: "space-between" }}>
                <div>
                  <div style={{ fontSize: 8, letterSpacing: "0.3em", color: "#444" }}>AVG TENSION</div>
                  <div style={{ fontSize: 22, fontWeight: 900, color: "#7fffd4", marginTop: 2 }}>{srcAvgTension} <span style={{ fontSize: 11, color: "#444" }}>lbs</span></div>
                </div>
                <div style={{ textAlign: "right" }}>
                  <div style={{ fontSize: 8, letterSpacing: "0.3em", color: "#444" }}>TOTAL PULL</div>
                  <div style={{ fontSize: 22, fontWeight: 900, color: "#ddd8cc", marginTop: 2 }}>{srcTensions.length ? srcTensions.reduce((a,b)=>a+b,0).toFixed(0) : "—"} <span style={{ fontSize: 11, color: "#444" }}>lbs</span></div>
                </div>
              </div>
            </div>

            {/* ── STEP 2: Target tuning/scale ── */}
            <div style={{ background: "#0a0f18", border: "1px solid #1a2040", borderRadius: 4, padding: "16px", marginBottom: 16 }}>
              <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#8888ee", marginBottom: 4 }}>STEP 2 — TARGET TUNING &amp; SCALE</div>
              <div style={{ fontSize: 10, color: "#333", marginBottom: 14 }}>The new setup you want to feel the same</div>
              <div style={{ marginBottom: 12 }}>
                <div style={{ fontSize: 8, letterSpacing: "0.3em", color: "#444", marginBottom: 6 }}>TUNING</div>
                <select value={tgtTuning} onChange={e => { setTgtTuning(e.target.value); setMatchGenerated(false); }} style={{ width: "100%", background: "#111", border: "1px solid #252525", color: "#ddd8cc", padding: "9px 8px", borderRadius: 3, fontSize: 12 }}>
                  {TUNING_GROUPS.map(grp => (
                    <optgroup key={grp} label={grp}>
                      {TUNING_LIST.filter(t => t.group === grp).map(t => (
                        <option key={t.id} value={t.id}>{t.label}</option>
                      ))}
                    </optgroup>
                  ))}
                </select>
              </div>
              <MultiScalePanel
                enabled={tgtMultiScale} onToggle={() => { setTgtMultiScale(v => !v); setMatchGenerated(false); }}
                singleScale={tgtScale} onSingleChange={v => { setTgtScale(v); setMatchGenerated(false); }}
                stringScales={tgtStringScales}
                onStringScaleChange={(i, v) => { const a = [...tgtStringScales]; a[i] = v; setTgtStringScales(a); setMatchGenerated(false); }}
                accentColor="#8888ee"
              />
            </div>

            {/* ── Generate button ── */}
            <button onClick={generateMatchFeel} disabled={!srcTensions.length} style={{ width: "100%", background: "#7fffd4", border: "none", borderRadius: 4, color: "#080808", fontSize: 12, fontWeight: 900, letterSpacing: "0.2em", padding: "16px", cursor: "pointer", marginBottom: 22, transition: "all 0.3s" }}>
              MATCH THE FEEL →
            </button>

            {/* ── Results ── */}
            {matchGenerated && tgtGauges.length > 0 && (
              <div style={{ marginBottom: 18 }}>
                <div style={{ background: "#0a0f18", border: "1px solid #1a2040", borderRadius: 4, padding: "16px", marginBottom: 14 }}>
                  <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#8888ee", marginBottom: 4 }}>MATCHED GAUGES</div>
                  <div style={{ fontSize: 10, color: "#333", marginBottom: 12 }}>{tgtTuning} Std · {tgtMultiScale ? "multi-scale" : `${tgtScale}"`} · matched to {srcTuning} Std · {srcMultiScale ? "multi-scale" : `${srcScale}"`}</div>
                  <div style={{ fontSize: 8, color: "#333", marginBottom: 8, letterSpacing: "0.1em" }}>+/− to fine-tune · WND/PLN to toggle</div>
                  <div style={{ display: "grid", gap: 5, marginBottom: 12 }}>
                    {getStringNames(srcInstrument, srcStringCount, tgtTuning).map((name, i) => {
                      const pt = tgtMultiScale ? (tgtStringScales[i] ?? tgtScale) : null;
                      return (
                        <StringRow key={i} name={name} gauge={tgtGauges[i] || "—"} wound={tgtWound[i]} tension={tgtTensions[i]}
                          scale={pt} showScale={tgtMultiScale}
                          onBumpUp={() => bumpTgt(i, 1)} onBumpDown={() => bumpTgt(i, -1)} onToggleWound={() => toggleTgtWound(i)} />
                      );
                    })}
                  </div>

                  {/* Side-by-side tension comparison */}
                  <div style={{ background: "#070710", border: "1px solid #1a1a30", borderRadius: 3, padding: "12px 14px", marginBottom: 0 }}>
                    <div style={{ fontSize: 8, letterSpacing: "0.3em", color: "#444", marginBottom: 10 }}>TENSION COMPARISON</div>
                    <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 8 }}>
                      <div>
                        <div style={{ fontSize: 8, color: "#7fffd4", letterSpacing: "0.15em", marginBottom: 4 }}>SOURCE</div>
                        <div style={{ fontSize: 18, fontWeight: 900, color: "#7fffd4" }}>{srcAvgTension} <span style={{ fontSize: 10, color: "#444" }}>avg lbs</span></div>
                        <div style={{ fontSize: 9, color: "#444" }}>{srcTuning} · {srcMultiScale ? "multi-scale" : `${srcScale}"`}</div>
                      </div>
                      <div style={{ textAlign: "right" }}>
                        <div style={{ fontSize: 8, color: "#8888ee", letterSpacing: "0.15em", marginBottom: 4 }}>MATCHED</div>
                        <div style={{ fontSize: 18, fontWeight: 900, color: "#8888ee" }}>{tgtAvgTension} <span style={{ fontSize: 10, color: "#444" }}>avg lbs</span></div>
                        <div style={{ fontSize: 9, color: "#444" }}>{tgtTuning} · {tgtMultiScale ? "multi-scale" : `${tgtScale}"`}</div>
                      </div>
                    </div>
                  </div>
                </div>

                <button onClick={generateSetFromMatch} style={{ width: "100%", background: "#7fffd4", border: "none", borderRadius: 4, color: "#080808", fontSize: 12, fontWeight: 900, letterSpacing: "0.22em", padding: "16px", cursor: "pointer", marginBottom: 10 }}>GENERATE STRING SET →</button>
                <button onClick={() => { setBuyGauges(tgtGauges); setBuyWound(tgtWound); setBuyPackName(""); setScreen("buy"); }} style={{ width: "100%", background: "#111", border: "1px solid #7fffd4", borderRadius: 4, color: "#7fffd4", fontSize: 12, fontWeight: 700, letterSpacing: "0.18em", padding: "14px", cursor: "pointer", marginBottom: 10 }}>SHOP THIS SETUP →</button>
                <button onClick={() => { setGauges(tgtGauges); setWoundFlags(tgtWound); setScaleLength(tgtScale); setTuning(tgtTuning); setScreen("calculator"); }} style={{ width: "100%", background: "#111", border: "1px solid #ff6b35", borderRadius: 4, color: "#ff6b35", fontSize: 11, fontWeight: 700, letterSpacing: "0.15em", padding: "13px", cursor: "pointer", marginBottom: 10 }}>
                  EDIT IN CALCULATOR →
                </button>
                <SaveLoadPanel source="match" />
              </div>
            )}
            {!matchGenerated && <SaveLoadPanel source="match" />}
          </div>
        )}

        {/* ══ ARTISTS ═══════════════════════════════════════════════════════════ */}
        {screen === "artists" && (
          <div className="fadein" style={{ padding: "20px" }}>
            <div style={{ fontSize: 10, letterSpacing: "0.35em", color: "#8888ee", marginBottom: 12 }}>ARTIST TUNINGS</div>
            {/* Search */}
            <input
              type="text"
              placeholder="Search artist or band..."
              value={artistSearch}
              onChange={e => setArtistSearch(e.target.value)}
              style={{ width: "100%", boxSizing: "border-box", background: "#0f0f0f", border: "1px solid #252525", color: "#ddd8cc", padding: "10px 12px", borderRadius: 3, fontSize: 13, marginBottom: 12, outline: "none" }}
            />
            {/* Genre pills — wrap on small screens */}
            <div style={{ display: "flex", flexWrap: "wrap", gap: 6, marginBottom: 16 }}>
              {genres.map(g => (
                <button key={g} onClick={() => setFilter(g)} style={{ background: filter === g ? "#8888ee" : "#111", border: `1px solid ${filter === g ? "#8888ee" : "#222"}`, color: filter === g ? "#080808" : "#555", borderRadius: 20, padding: "5px 12px", cursor: "pointer", fontSize: 9, letterSpacing: "0.15em", whiteSpace: "nowrap" }}>{g}</button>
              ))}
            </div>
            <div style={{ display: "grid", gap: 10 }}>
              {filtered.map((artist, i) => (
                <button key={i} onClick={() => loadArtist(artist)} style={{ background: "#0f0f0f", border: "1px solid #181818", borderRadius: 4, padding: "16px 18px", cursor: "pointer", textAlign: "left" }}>
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
                    <div>
                      <div style={{ display: "flex", alignItems: "center", gap: 8, flexWrap: "wrap" }}>
                        <div style={{ fontSize: 16, fontWeight: 800, color: "#ddd8cc" }}>{artist.name}</div>
                        {artist.instrument === "bass" && <div style={{ fontSize: 8, background: "#10101a", color: "#8888ee", border: "1px solid #2a2a5a", borderRadius: 2, padding: "2px 6px", letterSpacing: "0.2em" }}>BASS</div>}
                        {artist.verified && <div style={{ fontSize: 8, background: "#0d2010", color: "#60d080", border: "1px solid #1a4020", borderRadius: 2, padding: "2px 6px", letterSpacing: "0.2em" }}>VERIFIED</div>}
                      </div>
                      <div style={{ fontSize: 11, color: "#555", marginTop: 2 }}>{artist.band} · {artist.era}</div>
                    </div>
                    <div style={{ textAlign: "right", flexShrink: 0 }}>
                      <div style={{ fontSize: 13, fontWeight: 700, color: "#8888ee" }}>{TUNING_MAP[artist.tuning]?.label || artist.tuning}</div>
                      <div style={{ fontSize: 10, color: "#3a3a3a", marginTop: 2 }}>{artist.scaleLength}"</div>
                    </div>
                  </div>
                  <div style={{ display: "flex", gap: 5, marginTop: 12, flexWrap: "wrap" }}>
                    {artist.gauges.map((g, gi) => <div key={gi} style={{ fontSize: 10, background: "#181818", borderRadius: 2, padding: "3px 7px", color: "#777", fontWeight: 700 }}>{g}</div>)}
                  </div>
                </button>
              ))}
            </div>
          </div>
        )}

        {/* ══ ARTIST DETAIL ═════════════════════════════════════════════════════ */}
        {screen === "detail" && selectedArtist && (
          <div className="fadein" style={{ padding: "20px" }}>
            <div style={{ fontSize: 10, letterSpacing: "0.35em", color: "#8888ee", marginBottom: 4 }}>{selectedArtist.band.toUpperCase()}</div>
            <div style={{ fontSize: 30, fontWeight: 900, color: "#ddd8cc", marginBottom: 4, lineHeight: 1.1 }}>{selectedArtist.name}</div>
            <div style={{ fontSize: 12, color: "#444", marginBottom: 24 }}>{selectedArtist.era}</div>
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: 8, marginBottom: 22 }}>
              {[{ label: "TUNING", value: TUNING_MAP[selectedArtist.tuning]?.label || selectedArtist.tuning }, { label: "SCALE", value: `${selectedArtist.scaleLength}"` }, { label: "SOURCE", value: selectedArtist.verified ? "VERIFIED" : "APPROX" }].map((item, idx) => (
                <div key={idx} style={{ background: "#0f0f0f", border: "1px solid #181818", borderRadius: 4, padding: "12px 10px" }}>
                  <div style={{ fontSize: 8, letterSpacing: "0.3em", color: "#3a3a3a" }}>{item.label}</div>
                  <div style={{ fontSize: 12, fontWeight: 700, color: item.label === "SOURCE" && selectedArtist.verified ? "#60d080" : "#ddd8cc", marginTop: 5 }}>{item.value}</div>
                </div>
              ))}
            </div>
            <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#444", marginBottom: 10 }}>STRING DATA</div>
            <div style={{ display: "grid", gap: 6, marginBottom: 20 }}>
              {(selectedArtist.instrument === "bass" ? BASS_STRING_NAMES[selectedArtist.gauges.length] || BASS_STRING_NAMES[4] : GUITAR_STRING_NAMES[selectedArtist.gauges.length] || GUITAR_STRING_NAMES[6]).map((name, i) => {
                const { val, wound } = parseGauge(selectedArtist.gauges[i]);
                const freq = getStringFreqs(selectedArtist.instrument === "bass" ? "bass" : "guitar", selectedArtist.gauges.length, selectedArtist.tuning)[i];
                const t = calcTension(val, wound, selectedArtist.scaleLength, freq, stringTypeMult);
                return (
                  <div key={i} style={{ display: "grid", gridTemplateColumns: "28px 60px 32px 1fr 68px", alignItems: "center", gap: 8, background: "#0f0f0f", borderRadius: 3, padding: "10px 12px" }}>
                    <div style={{ fontSize: 9, color: "#3a3a3a", fontWeight: 700 }}>{name}</div>
                    <div style={{ fontSize: 14, fontWeight: 700, color: "#ddd8cc" }}>{val}</div>
                    <div style={{ fontSize: 7, fontWeight: 900, color: wound ? "#aa7700" : "#5566aa", background: wound ? "#1a1000" : "#0d0d18", border: `1px solid ${wound ? "#554400" : "#222244"}`, borderRadius: 2, padding: "2px 3px", textAlign: "center" }}>{wound ? "WND" : "PLN"}</div>
                    <div style={{ height: 3, background: "#181818", borderRadius: 2, overflow: "hidden" }}>
                      <div style={{ height: "100%", width: `${Math.min(100, t / 35 * 100)}%`, background: tensionColor(t), borderRadius: 2 }} />
                    </div>
                    <div style={{ textAlign: "right", fontSize: 12, fontWeight: 700, color: tensionColor(t) }}>{t ? `${t} lbs` : "—"}</div>
                  </div>
                );
              })}
            </div>
            <div style={{ background: "#0f0f0f", border: "1px solid #181818", borderRadius: 4, padding: "14px 16px", marginBottom: 18 }}>
              <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#3a3a3a", marginBottom: 7 }}>SETUP NOTES</div>
              <div style={{ fontSize: 12, color: "#777", lineHeight: 1.7 }}>{selectedArtist.notes}</div>
            </div>
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 10 }}>
              <button onClick={() => setScreen("calculator")} style={{ background: "#111", border: "1px solid #ff6b35", borderRadius: 4, color: "#ff6b35", fontSize: 11, fontWeight: 700, letterSpacing: "0.15em", padding: "14px", cursor: "pointer" }}>EDIT IN CALC</button>
              <button onClick={generateSet} style={{ background: "#ff6b35", border: "none", borderRadius: 4, color: "#080808", fontSize: 11, fontWeight: 900, letterSpacing: "0.15em", padding: "14px", cursor: "pointer" }}>GENERATE SET</button>
            </div>
          </div>
        )}

        {/* ══ GENERATED SET ═════════════════════════════════════════════════════ */}
        {screen === "generated" && generatedSet && (
          <div className="fadein" style={{ padding: "20px" }}>
            <div style={{ fontSize: 10, letterSpacing: "0.35em", color: "#ff6b35", marginBottom: 20 }}>YOUR STRING SET</div>
            <div style={{ background: "linear-gradient(135deg, #100800, #1c1000)", border: "1px solid #ff6b35", borderRadius: 6, padding: "22px", marginBottom: 18 }}>
              <div style={{ fontSize: 8, letterSpacing: "0.5em", color: "#ff6b35", marginBottom: 4 }}>DOWNTUNE · CUSTOM STRING SET</div>
              <div style={{ fontSize: 20, fontWeight: 900, color: "#ddd8cc", marginBottom: 2 }}>{selectedArtist ? selectedArtist.name : "Custom"} Setup</div>
              <div style={{ fontSize: 11, color: "#555", marginBottom: 18 }}>{TUNING_MAP[tuning]?.label || tuning} · {scaleLength}"</div>
              <div style={{ display: "grid", gap: 8 }}>
                {generatedSet.map((s, i) => (
                  <div key={i} style={{ display: "flex", alignItems: "center", gap: 10 }}>
                    <div style={{ fontSize: 10, color: "#555", width: 28 }}>{s.string}</div>
                    <div style={{ fontSize: 15, fontWeight: 800, color: "#ddd8cc", width: 52 }}>{s.gauge}</div>
                    <div style={{ fontSize: 8, color: s.wound ? "#aa7700" : "#5566aa", width: 26 }}>{s.wound ? "WND" : "PLN"}</div>
                    <div style={{ flex: 1, height: 2, background: "#2a1800" }}>
                      <div style={{ height: "100%", width: `${Math.min(100, s.tension / 35 * 100)}%`, background: tensionColor(s.tension) }} />
                    </div>
                    <div style={{ fontSize: 12, color: tensionColor(s.tension), fontWeight: 700, minWidth: 52, textAlign: "right" }}>{s.tension} lbs</div>
                  </div>
                ))}
              </div>
              <div style={{ borderTop: "1px solid #2a1500", marginTop: 18, paddingTop: 14, display: "flex", justifyContent: "space-between" }}>
                <div style={{ fontSize: 10, color: "#444" }}>AVG {(generatedSet.reduce((a, b) => a + b.tension, 0) / generatedSet.length).toFixed(1)} lbs</div>
                <div style={{ fontSize: 10, color: "#444" }}>TOTAL {generatedSet.reduce((a, b) => a + b.tension, 0).toFixed(0)} lbs</div>
              </div>
            </div>
            <button onClick={() => setShared(true)} style={{ width: "100%", background: shared ? "#1a2a1a" : "#1a1a2a", border: `1px solid ${shared ? "#60d080" : "#5555aa"}`, borderRadius: 4, color: shared ? "#60d080" : "#8888ee", fontSize: 12, fontWeight: 700, letterSpacing: "0.2em", padding: "14px", cursor: "pointer", marginBottom: 10 }}>
              {shared ? "✓ COPIED TO CLIPBOARD" : "⬆ SHARE THIS SET"}
            </button>
            <BuyPanel gauges={generatedSet.map(s => s.gauge)} woundArr={generatedSet.map(s => s.wound)} onBuy={(g, w, name) => { setBuyGauges(g); setBuyWound(w); setBuyPackName(name); setScreen("buy"); }} />
          </div>
        )}

        {/* ══ MY SETUPS ════════════════════════════════════════════════════════════ */}
        {screen === "setups" && (
          <div className="fadein" style={{ padding: "20px" }}>
            <div style={{ fontSize: 10, letterSpacing: "0.35em", color: "#ff6b35", marginBottom: 4 }}>MY SETUPS</div>
            <div style={{ fontSize: 13, color: "#555", marginBottom: 22, lineHeight: 1.6 }}>
              {savedSetups.length === 0 ? "No saved setups yet. Build one and hit Save." : `${savedSetups.length} saved setup${savedSetups.length === 1 ? "" : "s"}`}
            </div>

            {savedSetups.length === 0 && (
              <button onClick={() => setScreen("calculator")} style={{ width: "100%", background: "#ff6b35", border: "none", borderRadius: 4, color: "#080808", fontSize: 12, fontWeight: 900, letterSpacing: "0.2em", padding: "16px", cursor: "pointer" }}>
                GO TO CALCULATOR →
              </button>
            )}

            <div style={{ display: "grid", gap: 10 }}>
              {savedSetups.map((setup, idx) => (
                <div key={setup.id} style={{ background: "#0f0f0f", border: `1px solid ${renamingId === setup.id ? "#ff6b35" : "#1a1a1a"}`, borderRadius: 4, overflow: "hidden", transition: "border-color 0.2s" }}>

                  {/* Header: name + date */}
                  <div style={{ padding: "14px 16px 10px", display: "flex", alignItems: "flex-start", justifyContent: "space-between", gap: 10 }}>
                    <div style={{ flex: 1, minWidth: 0 }}>
                      {renamingId === setup.id ? (
                        <div style={{ display: "flex", gap: 7 }}>
                          <input
                            autoFocus
                            value={renameVal}
                            onChange={e => setRenameVal(e.target.value)}
                            onKeyDown={e => {
                              if (e.key === "Enter") renameSetup(setup.id, renameVal);
                              if (e.key === "Escape") { setRenamingId(null); setRenameVal(""); }
                            }}
                            style={{ flex: 1, background: "#111", border: "1px solid #ff6b35", color: "#ddd8cc", padding: "7px 10px", borderRadius: 3, fontSize: 13, fontWeight: 700 }}
                          />
                          <button onClick={() => renameSetup(setup.id, renameVal)} style={{ background: "#ff6b35", border: "none", borderRadius: 3, color: "#080808", fontSize: 10, fontWeight: 900, padding: "0 12px", cursor: "pointer" }}>OK</button>
                          <button onClick={() => { setRenamingId(null); setRenameVal(""); }} style={{ background: "#111", border: "1px solid #252525", borderRadius: 3, color: "#555", fontSize: 10, padding: "0 10px", cursor: "pointer" }}>✕</button>
                        </div>
                      ) : (
                        <div style={{ fontSize: 16, fontWeight: 800, color: "#ddd8cc", overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{setup.name}</div>
                      )}
                      <div style={{ fontSize: 9, color: "#333", marginTop: 4, letterSpacing: "0.1em" }}>Saved {setup.savedAt}</div>
                    </div>
                    {/* Index badge */}
                    <div style={{ fontSize: 10, color: "#333", fontWeight: 700, flexShrink: 0 }}>#{idx + 1}</div>
                  </div>

                  {/* Setup details */}
                  <div style={{ padding: "0 16px 12px", display: "flex", gap: 8, flexWrap: "wrap" }}>
                    <div style={{ fontSize: 9, background: "#181818", borderRadius: 2, padding: "3px 8px", color: "#666", letterSpacing: "0.1em" }}>{setup.tuning} Std</div>
                    <div style={{ fontSize: 9, background: "#181818", borderRadius: 2, padding: "3px 8px", color: "#666", letterSpacing: "0.1em" }}>{typeof setup.scaleLength === "number" ? `${setup.scaleLength}"` : setup.scaleLength}</div>
                    <div style={{ fontSize: 9, background: "#181818", borderRadius: 2, padding: "3px 8px", color: "#666", letterSpacing: "0.1em" }}>{setup.gauges[0]}–{setup.gauges[setup.gauges.length - 1]}</div>
                  </div>

                  {/* Gauge chips */}
                  <div style={{ padding: "0 16px 14px", display: "flex", gap: 5, flexWrap: "wrap" }}>
                    {setup.gauges.map((g, gi) => (
                      <div key={gi} style={{ fontSize: 10, background: "#141414", border: "1px solid #222", borderRadius: 3, padding: "4px 8px", color: setup.woundFlags?.[gi] ? "#aa7700" : "#5566aa", fontWeight: 700 }}>
                        {g}{setup.woundFlags?.[gi] ? "w" : ""}
                      </div>
                    ))}
                  </div>

                  {/* Action row */}
                  <div style={{ borderTop: "1px solid #141414", display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: 0 }}>
                    <button
                      onClick={() => { loadSetup(setup); setScreen("calculator"); }}
                      style={{ background: "none", border: "none", borderRight: "1px solid #141414", color: "#ff6b35", fontSize: 10, fontWeight: 900, letterSpacing: "0.15em", padding: "13px 8px", cursor: "pointer" }}>
                      ▶ LOAD
                    </button>
                    <button
                      onClick={() => { setRenamingId(setup.id); setRenameVal(setup.name); }}
                      style={{ background: "none", border: "none", borderRight: "1px solid #141414", color: "#888", fontSize: 10, fontWeight: 700, letterSpacing: "0.12em", padding: "13px 8px", cursor: "pointer" }}>
                      ✎ RENAME
                    </button>
                    <button
                      onClick={() => deleteSetup(setup.id)}
                      style={{ background: "none", border: "none", color: "#444", fontSize: 10, fontWeight: 700, letterSpacing: "0.12em", padding: "13px 8px", cursor: "pointer" }}
                      onMouseEnter={e => e.currentTarget.style.color = "#ff4466"}
                      onMouseLeave={e => e.currentTarget.style.color = "#444"}>
                      ✕ DELETE
                    </button>
                  </div>
                </div>
              ))}
            </div>

            {savedSetups.length > 0 && (
              <button
                onClick={() => { if (window.confirm(`Delete all ${savedSetups.length} saved setups?`)) { setSavedSetups([]); persist([]); } }}
                style={{ width: "100%", marginTop: 16, background: "none", border: "1px solid #2a1010", borderRadius: 4, color: "#444", fontSize: 10, fontWeight: 700, letterSpacing: "0.2em", padding: "13px", cursor: "pointer" }}>
                DELETE ALL SETUPS
              </button>
            )}
          </div>
        )}

        {/* ══ DIAGNOSTICS ═══════════════════════════════════════════════════════ */}
        {screen === "diagnostics" && (
          <div className="fadein" style={{ padding: "20px" }}>
            <div style={{ fontSize: 10, letterSpacing: "0.35em", color: "#ddaa00", marginBottom: 8 }}>STRING DIAGNOSTICS</div>
            <div style={{ fontSize: 13, color: "#555", marginBottom: 22, lineHeight: 1.7 }}>What&apos;s wrong with how your strings feel?</div>
            <div style={{ display: "grid", gap: 12 }}>
              {DIAGNOSTICS.map((d) => (
                <button key={d.id} onClick={() => setActiveDiag(activeDiag === d.id ? null : d.id)} style={{ background: activeDiag === d.id ? "#141000" : "#0f0f0f", border: `1px solid ${activeDiag === d.id ? "#ddaa00" : "#181818"}`, borderRadius: 4, padding: "18px", cursor: "pointer", textAlign: "left", transition: "all 0.2s" }}>
                  <div style={{ display: "flex", alignItems: "center", gap: 14 }}>
                    <div style={{ fontSize: 28, minWidth: 36 }}>{d.icon}</div>
                    <div>
                      <div style={{ fontSize: 16, fontWeight: 800, color: "#ddd8cc" }}>{d.label}</div>
                      <div style={{ fontSize: 12, color: "#555", marginTop: 3, lineHeight: 1.5 }}>{d.description}</div>
                    </div>
                  </div>
                  {activeDiag === d.id && (
                    <div style={{ marginTop: 16, borderTop: "1px solid #2a2000", paddingTop: 16 }}>
                      <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#ddaa00", marginBottom: 10 }}>FIXES</div>
                      <div style={{ display: "grid", gap: 9 }}>
                        {d.fixes.map((fix, fi) => <div key={fi} style={{ display: "flex", gap: 10, fontSize: 12, color: "#999", lineHeight: 1.5 }}><span style={{ color: "#ddaa00", flexShrink: 0 }}>→</span>{fix}</div>)}
                      </div>
                      <button onClick={(e) => { e.stopPropagation(); setScreen("calculator"); }} style={{ marginTop: 14, background: "#ddaa00", border: "none", borderRadius: 3, color: "#080808", fontSize: 10, fontWeight: 900, letterSpacing: "0.22em", padding: "10px 18px", cursor: "pointer" }}>RECALCULATE →</button>
                    </div>
                  )}
                </button>
              ))}
            </div>
          </div>
        )}

        {/* ══ SCANNER / STRING SEARCH ══════════════════════════════════════════ */}
        {screen === "scanner" && (
          <div className="fadein" style={{ padding: "20px" }}>
            <div style={{ fontSize: 10, letterSpacing: "0.35em", color: "#7fffd4", marginBottom: 4 }}>STRINGS</div>
            <div style={{ fontSize: 13, color: "#555", marginBottom: 20, lineHeight: 1.6 }}>Scan a barcode or search by brand, gauge, or pack name to load gauges.</div>

            {/* ── Camera / Barcode scanner ── */}
            <div style={{ background: "#0a0f0a", border: "1px solid #1a3020", borderRadius: 4, marginBottom: 16, overflow: "hidden" }}>

              {/* Header row */}
              <div style={{ padding: "14px 16px", display: "flex", alignItems: "center", justifyContent: "space-between" }}>
                <div>
                  <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#7fffd4" }}>BARCODE SCANNER</div>
                  <div style={{ fontSize: 10, color: "#444", marginTop: 3 }}>Scan any string pack barcode</div>
                </div>
                <div style={{ display: "flex", gap: 7 }}>
                  {/* iOS / camera-roll fallback */}
                  <label style={{ background: "#0d1a10", border: "1px solid #2a4030", borderRadius: 3, color: "#3a6050", fontSize: 9, fontWeight: 900, letterSpacing: "0.1em", padding: "8px 11px", cursor: "pointer", display: "flex", alignItems: "center", gap: 5 }}>
                    📷 PHOTO
                    <input type="file" accept="image/*" capture="environment" onChange={handleImageCapture} style={{ display: "none" }} />
                  </label>
                  {/* Live camera toggle */}
                  <button
                    onClick={() => {
                      if (cameraActive) { stopCamera(); } 
                      else { setCameraError(""); setScanResult(null); setCameraActive(true); }
                    }}
                    style={{ background: cameraActive ? "#1a3020" : "#0d1a10", border: `1px solid ${cameraActive ? "#7fffd4" : "#2a4030"}`, borderRadius: 3, color: cameraActive ? "#7fffd4" : "#3a6050", fontSize: 9, fontWeight: 900, letterSpacing: "0.1em", padding: "8px 11px", cursor: "pointer" }}>
                    {cameraActive ? "■ STOP" : "▶ LIVE"}
                  </button>
                </div>
              </div>

              {/* Live viewfinder */}
              {cameraActive && (
                <div style={{ position: "relative", background: "#000", height: 220 }}>
                  <video
                    ref={el => {
                      if (!el) return;
                      if (cameraActive && !el.srcObject) {
                        navigator.mediaDevices?.getUserMedia({
                          video: { facingMode: "environment", width: { ideal: 1280 }, height: { ideal: 720 } }
                        }).then(stream => {
                          el.srcObject = stream;
                          el.play().then(() => startBarcodeLoop(el));
                        }).catch(() => {
                          setCameraError("Camera access denied — check your browser permissions.");
                          setCameraActive(false);
                        });
                      }
                    }}
                    style={{ width: "100%", height: "100%", objectFit: "cover" }}
                    playsInline muted autoPlay
                  />
                  {/* Viewfinder overlay */}
                  <div style={{ position: "absolute", inset: 0, display: "flex", alignItems: "center", justifyContent: "center", pointerEvents: "none" }}>
                    <div style={{ width: 240, height: 90, position: "relative" }}>
                      {[[0,0],[0,1],[1,0],[1,1]].map(([r,c], ki) => (
                        <div key={ki} style={{ position: "absolute", top: r===0?0:"auto", bottom: r===1?0:"auto", left: c===0?0:"auto", right: c===1?0:"auto", width: 20, height: 20, borderTop: r===0?"2px solid #7fffd4":"none", borderBottom: r===1?"2px solid #7fffd4":"none", borderLeft: c===0?"2px solid #7fffd4":"none", borderRight: c===1?"2px solid #7fffd4":"none" }} />
                      ))}
                      {scanDetecting && (
                        <div style={{ position: "absolute", top: "50%", left: "5%", right: "5%", height: 2, background: "rgba(127,255,212,0.7)", boxShadow: "0 0 8px #7fffd4", animation: "scanline 1.4s ease-in-out infinite", marginTop: -1 }} />
                      )}
                    </div>
                  </div>
                  <div style={{ position: "absolute", bottom: 10, left: 0, right: 0, textAlign: "center", fontSize: 9, letterSpacing: "0.25em" }}>
                    {scanDetecting
                      ? <span style={{ color: "#7fffd4" }}>● SCANNING…</span>
                      : <span style={{ color: "rgba(127,255,212,0.4)" }}>ALIGN BARCODE IN FRAME</span>}
                  </div>
                </div>
              )}

              {/* Scan result banner */}
              {scanResult && (
                <div style={{ padding: "12px 16px", background: scanResult.pack ? "#0a1a10" : "#1a0800", borderTop: `1px solid ${scanResult.pack ? "#1a4020" : "#3a1500"}` }}>
                  {scanResult.pack ? (
                    <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
                      <div style={{ fontSize: 16, color: "#60d080" }}>✓</div>
                      <div>
                        <div style={{ fontSize: 12, fontWeight: 800, color: "#ddd8cc" }}>{scanResult.pack.brand} {scanResult.pack.name}</div>
                        <div style={{ fontSize: 9, color: "#444", marginTop: 2 }}>Loaded into Calculator</div>
                      </div>
                    </div>
                  ) : (
                    <div>
                      <div style={{ fontSize: 10, color: "#ff6b35", fontWeight: 700 }}>Barcode not in database: {scanResult.code}</div>
                      <div style={{ fontSize: 9, color: "#555", marginTop: 3 }}>Search results updated below</div>
                    </div>
                  )}
                </div>
              )}

              {/* Error */}
              {cameraError && (
                <div style={{ padding: "10px 16px", fontSize: 11, color: "#ff6b35", background: "#1a0800", borderTop: "1px solid #3a1500" }}>{cameraError}</div>
              )}

              {/* Platform note */}
              <div style={{ padding: "8px 16px 12px", fontSize: 9, color: "#252525", lineHeight: 1.6 }}>
                LIVE works on Android Chrome · Use PHOTO on iPhone (tap, then point camera at barcode)
              </div>
            </div>

            {/* ── Search bar ── */}
            <div style={{ display: "flex", gap: 8, marginBottom: 14 }}>
              <input
                placeholder="Search brand, gauge, pack name..."
                value={scannerQuery}
                onChange={e => { setScannerQuery(e.target.value); runScannerSearch(e.target.value, undefined, undefined); }}
                onKeyDown={e => e.key === "Enter" && runScannerSearch()}
                style={{ flex: 1, background: "#0f0f0f", border: "1px solid #252525", color: "#ddd8cc", padding: "12px 14px", borderRadius: 3, fontSize: 13, outline: "none" }}
              />
              <button onClick={() => runScannerSearch()} style={{ background: "#7fffd4", border: "none", borderRadius: 3, color: "#080808", fontSize: 11, fontWeight: 900, padding: "0 16px", cursor: "pointer", letterSpacing: "0.1em" }}>GO</button>
            </div>

            {/* ── Filters ── */}
            <div style={{ display: "flex", gap: 6, marginBottom: 14, flexWrap: "wrap" }}>
              {/* Type filter */}
              {[["all","ALL"],["electric","ELECTRIC"],["bass","BASS"]].map(([v, label]) => (
                <button key={v} onClick={() => { setScannerFilter(v); runScannerSearch(undefined, v, undefined); }} style={{ background: scannerFilter===v ? "#7fffd4" : "#111", border: `1px solid ${scannerFilter===v ? "#7fffd4" : "#252525"}`, borderRadius: 20, color: scannerFilter===v ? "#080808" : "#555", fontSize: 9, fontWeight: 700, letterSpacing: "0.12em", padding: "5px 12px", cursor: "pointer" }}>{label}</button>
              ))}
              <div style={{ width: 1, background: "#222", margin: "0 2px" }} />
              {/* Brand filter */}
              {["all", ...new Set(STRING_PACKS.map(p => p.brand))].map(b => (
                <button key={b} onClick={() => { setScannerBrand(b); runScannerSearch(undefined, undefined, b); }} style={{ background: scannerBrand===b ? "#ff6b35" : "#111", border: `1px solid ${scannerBrand===b ? "#ff6b35" : "#252525"}`, borderRadius: 20, color: scannerBrand===b ? "#080808" : "#555", fontSize: 9, fontWeight: 700, letterSpacing: "0.1em", padding: "5px 12px", cursor: "pointer", whiteSpace: "nowrap" }}>{b === "all" ? "ALL BRANDS" : b}</button>
              ))}
            </div>

            {/* ── Results or default listing ── */}
            {(() => {
              const displayPacks = scannerResults.length > 0 || scannerQuery
                ? scannerResults
                : STRING_PACKS.filter(p => (scannerFilter === "all" || p.type === scannerFilter) && (scannerBrand === "all" || p.brand === scannerBrand));
              const brands = [...new Set(displayPacks.map(p => p.brand))];
              return (
                <div>
                  {displayPacks.length === 0 && (
                    <div style={{ textAlign: "center", padding: "30px 20px", color: "#333", fontSize: 12 }}>No packs found. Try a different search.</div>
                  )}
                  {brands.map(brand => {
                    const brandPacks = displayPacks.filter(p => p.brand === brand);
                    return (
                      <div key={brand} style={{ marginBottom: 18 }}>
                        <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#444", marginBottom: 8, paddingLeft: 2 }}>{brand.toUpperCase()}</div>
                        <div style={{ display: "grid", gap: 7 }}>
                          {brandPacks.map(pack => (
                            <div key={pack.id} style={{ background: scannerLoaded?.id === pack.id ? "#0a1a10" : "#0f0f0f", border: `1px solid ${scannerLoaded?.id === pack.id ? "#7fffd4" : "#1a1a1a"}`, borderRadius: 4, padding: "12px 14px", display: "flex", alignItems: "center", gap: 12 }}>
                              <div style={{ flex: 1, minWidth: 0 }}>
                                <div style={{ display: "flex", alignItems: "center", gap: 6, flexWrap: "wrap" }}>
                                  <div style={{ fontSize: 13, fontWeight: 800, color: "#ddd8cc" }}>{pack.name}</div>
                                  <div style={{ fontSize: 8, color: "#555", background: "#181818", borderRadius: 2, padding: "2px 6px", letterSpacing: "0.1em" }}>{pack.line}</div>
                                  <div style={{ fontSize: 8, color: pack.type === "bass" ? "#8888ee" : "#7fffd4", background: pack.type === "bass" ? "#0e0e1c" : "#0a1410", borderRadius: 2, padding: "2px 6px", letterSpacing: "0.1em" }}>{pack.type.toUpperCase()}</div>
                                </div>
                                <div style={{ display: "flex", gap: 4, marginTop: 6, flexWrap: "wrap" }}>
                                  {pack.gauges.map((g, gi) => (
                                    <div key={gi} style={{ fontSize: 9, background: "#181818", borderRadius: 2, padding: "2px 6px", color: g.endsWith("w") ? "#aa7700" : "#5566aa", fontWeight: 700 }}>{g}</div>
                                  ))}
                                </div>
                              </div>
                              <div style={{ display: "flex", flexDirection: "column", gap: 6, flexShrink: 0 }}>
                                <button onClick={() => loadPack(pack)} style={{ background: "#7fffd4", border: "none", borderRadius: 3, color: "#080808", fontSize: 9, fontWeight: 900, letterSpacing: "0.12em", padding: "7px 12px", cursor: "pointer" }}>
                                  {scannerLoaded?.id === pack.id ? "✓ LOADED" : "LOAD →"}
                                </button>
                                <button onClick={() => { setScreen("buy"); setBuyGauges(pack.gauges); setBuyWound(pack.gauges.map(g => g.endsWith("w"))); setBuyPackName(`${pack.brand} ${pack.name}`); }} style={{ background: "#111", border: "1px solid #252525", borderRadius: 3, color: "#555", fontSize: 9, fontWeight: 700, letterSpacing: "0.1em", padding: "6px 10px", cursor: "pointer" }}>
                                  BUY
                                </button>
                              </div>
                            </div>
                          ))}
                        </div>
                      </div>
                    );
                  })}
                </div>
              );
            })()}
          </div>
        )}

        {/* ══ BUY SCREEN ════════════════════════════════════════════════════════ */}
        {screen === "buy" && (
          <div className="fadein" style={{ padding: "20px" }}>
            <button onClick={() => setScreen("scanner")} style={{ background: "none", border: "none", color: "#555", cursor: "pointer", fontSize: 12, letterSpacing: "0.2em", marginBottom: 20, padding: 0 }}>← BACK TO STRINGS</button>
            <div style={{ fontSize: 10, letterSpacing: "0.35em", color: "#ff6b35", marginBottom: 4 }}>BUY STRINGS</div>
            {buyPackName && <div style={{ fontSize: 18, fontWeight: 900, color: "#ddd8cc", marginBottom: 4 }}>{buyPackName}</div>}
            <div style={{ display: "flex", gap: 4, marginBottom: 20, flexWrap: "wrap" }}>
              {buyGauges.map((g, i) => (
                <div key={i} style={{ fontSize: 10, background: "#181818", borderRadius: 2, padding: "3px 7px", color: buyWound[i] ? "#aa7700" : "#5566aa", fontWeight: 700 }}>{g}</div>
              ))}
            </div>

            {/* Closest packs */}
            {(() => {
              const matches = STRING_PACKS
                .filter(p => p.gauges.length === buyGauges.length || Math.abs(p.gauges.length - buyGauges.length) <= 1)
                .map(p => ({ pack: p, score: scorePackMatch(p.gauges, buyGauges) }))
                .sort((a, b) => a.score - b.score)
                .slice(0, 4);
              return matches.length > 0 && matches[0].score < 0.02 ? (
                <div style={{ marginBottom: 20 }}>
                  <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#444", marginBottom: 10 }}>CLOSEST MATCHING PACKS</div>
                  {matches.map(({ pack, score }) => (
                    <div key={pack.id} style={{ background: "#0f0f0f", border: `1px solid ${score < 0.001 ? "#7fffd4" : "#1a1a1a"}`, borderRadius: 4, padding: "12px 14px", marginBottom: 8, display: "flex", alignItems: "center", gap: 10 }}>
                      <div style={{ flex: 1 }}>
                        <div style={{ fontSize: 12, fontWeight: 700, color: "#ddd8cc" }}>{pack.brand} {pack.name}</div>
                        <div style={{ fontSize: 9, color: "#444", marginTop: 3 }}>{pack.gauges.join(" · ")}</div>
                      </div>
                      {score < 0.001
                        ? <div style={{ fontSize: 8, color: "#7fffd4", border: "1px solid #1a4020", borderRadius: 2, padding: "2px 6px", letterSpacing: "0.15em", flexShrink: 0 }}>EXACT</div>
                        : <div style={{ fontSize: 9, color: "#555", flexShrink: 0 }}>~{(score * 1000).toFixed(0)} off</div>
                      }
                    </div>
                  ))}
                </div>
              ) : null;
            })()}

            <div style={{ fontSize: 9, letterSpacing: "0.3em", color: "#444", marginBottom: 12 }}>SHOP AT</div>
            <div style={{ display: "grid", gap: 10 }}>
              {RETAILERS.map(r => {
                const firstNum = Math.round(parseFloat((buyGauges[0]||".010").replace(/[wp]/g,"")) * 1000);
                const lastNum  = Math.round(parseFloat((buyGauges[buyGauges.length-1]||".046").replace(/[wp]/g,"")) * 1000);
                const term = buyPackName || `guitar strings ${firstNum}-${lastNum}`;
                return (
                  <a key={r.name} href={r.buildUrl(term)} target="_blank" rel="noopener noreferrer"
                    style={{ background: "#111", border: `1px solid #222`, borderRadius: 4, color: "#ddd8cc", fontSize: 13, fontWeight: 700, padding: "16px 18px", cursor: "pointer", textDecoration: "none", display: "flex", alignItems: "center", justifyContent: "space-between" }}>
                    <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
                      <span style={{ fontSize: 20 }}>{r.icon}</span>
                      <div>
                        <div style={{ fontSize: 13, fontWeight: 800 }}>{r.name}</div>
                        <div style={{ fontSize: 9, color: "#444", marginTop: 2, letterSpacing: "0.1em" }}>Search: {term.slice(0, 30)}{term.length > 30 ? "…" : ""}</div>
                      </div>
                    </div>
                    <div style={{ color: r.color, fontSize: 16 }}>→</div>
                  </a>
                );
              })}
            </div>
            <div style={{ marginTop: 16, padding: "12px 14px", background: "#0a0a0a", borderRadius: 3, border: "1px solid #141414" }}>
              <div style={{ fontSize: 9, color: "#2a2a2a", letterSpacing: "0.15em", lineHeight: 1.8 }}>
                Links include affiliate tracking. Purchases may earn a commission at no extra cost to you.
              </div>
            </div>
          </div>
        )}

      </div>

      {/* ── BOTTOM NAV ── */}
      <div style={{ position: "fixed", bottom: 0, left: "50%", transform: "translateX(-50%)", width: "100%", maxWidth: 430, background: "linear-gradient(0deg, #080808 80%, transparent)", borderTop: "1px solid #141414", padding: "10px 0 22px", display: "grid", gridTemplateColumns: "repeat(5, 1fr)", zIndex: 100 }}>
        {navItems.map(tab => (
          <button key={tab.id} onClick={() => setScreen(tab.id)} style={{ background: "none", border: "none", cursor: "pointer", display: "flex", flexDirection: "column", alignItems: "center", gap: 4, padding: "6px 0" }}>
            <div style={{ fontSize: 17, color: screen === tab.id ? "#ff6b35" : "#333", transition: "color 0.2s" }}>{tab.icon}</div>
            <div style={{ fontSize: 8, letterSpacing: "0.2em", color: screen === tab.id ? "#ff6b35" : "#2a2a2a" }}>{tab.label}</div>
          </button>
        ))}
      </div>
    </div>
  );
}

export default function App() { return <ErrorBoundary><DownTune /></ErrorBoundary>; }

