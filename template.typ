
#let acronyms = yaml("acronyms.yml");
#let acroStates = state("acronymStates", ());

#let english_pack = (
	by: "by",
	time_period: "Time Period",
        student_id: "Student ID",
	company: "Company",
	supervisor: "Advisor",
        first_referee: "1. Referee",
        second_referee: "2. Referee", 
	decleration: (type, title) => [
		= Author's Declaration
                I declare under oath that I have prepared the paper at hand independently
                and without the help of others and that I have not used any other sources
                and resources than the ones stated. Parts that have been taken literally or
                correspondingly from published or unpublished texts or other sources have
                been labelled as such. This paper has not been presented to any examination
                board in the same or similar form before.
	],
	abstract: "Abstract",
	contents: "Contents",
	list_of_figures: "List of Figures",
	acronyms: "Acronyms",
	bibliography: "Bibliography",
	appendix: "Appendix",
	chapter: "Chapter",
	section: "Section",
	confidentiality_clause: [
		= Confidentiality Clause

		The content of this work may not be made accessible to people outside of the
		testing process and the evaluation process neither as a whole nor as excerpts,
		unless an authorization stating otherwise is presented by the training facility.
	]
)

// TODO: Check alignment to LaTeX template
#let german_pack = (
	by: "von",
	time_period: "Bearbeitungszeitraum",
	student_id_course: "Matrikelnummer, Kurs",
	company: "Ausbildungsfirma",
	supervisor: "Betreuer",
        first_referee: "1. Korrekteur",
        second_referee: "2. Korrekteur",
	decleration: (type, title) => [
		== Erklärung

		Ich erkläre hiermit ehrenwörtlich:
		+ dass ich meine #type mit dem Thema #title ohne fremde Hilfe
			angefertigt habe;
		+ dass ich die Übernahme wörtlicher Zitate aus der Literatur sowie die Verwendung
			der Gedanken anderer Autoren an den entsprechenden Stellen innerhalb der
			Arbeit gekennzeichnet habe;
		+ dass ich meine T1000 bei keiner anderen Prüfung vorgelegt habe;

		Ich bin mir bewusst, dass eine falsche Erklärung rechtliche Folgen haben wird.

		#title
		*a big & fat _TODO_!*
	],
	abstract: "Abstract",
	contents: "Inhaltsverzeichnis",
	list_of_figures: "Abbildungsverzeichnis",
	acronyms: "Abkürzungsverzeichnis",
	bibliography: "Literaturverzeichnis",
	appendix: "Anhang",
	chapter: "Kapitel",
	section: "Abschnitt",
	confidentiality_clause: [
		= Sperrvermerk
	
		Der Inhalt dieser Arbeit darf weder als Ganzes noch in Auszügen Personen außerhalb des
		Prüfungs- und des Evaluationsverfahrens zugänglich gemacht werden, sofern keine anders
		lautende Genehmigung des Dualen Partners vorliegt.
	]
)

#let thesis(
	// the title of your thesis
	title: none,
	// your name
	author: none,
	// your student id / matriculation number
	student_id: none,
	// the name of your course, such as "TINF21A"
	signature: none,

	// the name of your supervisor
	supervisor: none,
        first_referee: none,
        second_referee: none,

	// the due date of your thesis
	date: none,
	// the time period that the work described in your thesis took place in
	time_period: none,

	// the type of your thesis, such as T1000, T2000, etc.
	type: none,
	// your degree, such as "Bachelor of Science"
	degree: "Master of Science",
	// your major, such as "Computer Science"
	major: "Cyber Security",
	// Change the language to `de` if desired
	language: "en",

	// Details on your university
	university: (
		name: "Saarland university",
		location: "Saarbrücken",
		image: "assets/uds.svg",
	),

	//// Details on your company
	//company: (
	//	name: "Hewlett Packard Enterprise",
	//	image: "assets/hpe.svg",
	//),

	// Does the document require a Confidentiality Clause?
	confidentiality_clause: false,

	// Path to your bibliography file
	// You may use `.yml` for Hayagriva format
	// or `.bib` for BibLaTeX format
	bibliography_path: "literature.yml",
	// Citation style:
	// Customized includes ISBNs and
	// writes DOI in capital letters
	customized_ieee_citations: false,

	// The contents of your abstract
	abstract: include "./abstract.typ",
	// To be append after the bibliography
	appendix: none,

	// First chapter of your thesis
	// This is *not* required anymore
	// first_chapter_title: none,

	// Factor of page location when to pagebreak headings
	// to avoid a heading without content on the same page.
	// Can be disabled by setting it to none
	// WARNING: can result in "layout did not converge within 5 attempts" issue
	heading_pagebreak_percentage: none,

	// set automatically by using the template via `#show: thesis.with(...)
	body,
) = [
	// Assert all parameters are set
	#assert.ne(title, none)
	#assert.ne(author, none)
	#assert.ne(student_id, none)
	#assert.ne(type, none)
	#assert.ne(date, none)
	#assert.ne(time_period, none)
	#assert.ne(supervisor, none)
        #assert.ne(first_referee, none)
        #assert.ne(second_referee, none)

	// Use english by default
	#let selected_lang = if language == "de" {german_pack} else {english_pack}

	#set document(
		title: title,
		author: author,
		date: date,
	)

	#set page(
		paper: "a4",
		margin: 2.5cm,
		numbering: none, // don't number the first pages, i.e. titlepage and abstract
	)

	// suggested font and font size by the DHBW style guide
	#set text(
		font: "Libertinus Serif",
		// font: "New Computer Modern Sans",
		size: 12pt,
		hyphenate: false,
		lang: language,
		ligatures: true,
	)

	#set par(
		leading: 8pt, // 1.5x line spacing
		justify: true,
		linebreaks: "optimized",
	)

	// do not justify inside of figures, incl. tables
	#show figure: set par(justify: false)

	#set figure(
		numbering: "I"
	)

	// don't outline or number the first headings
	#set heading(
		numbering: none,
		outlined: false,
	)

	// modify the spacing between various headings and the content below them
	#show heading: it => {
		let sizes = if it.level == 1 {
			(64pt, 24pt, 24pt)
		} else if it.level == 2 {
			(32pt, 20pt, 18pt)
		} else {
			(24pt, 16pt, 14pt)
		}

		// On top-level headers, do a weak pagebreak
		// (weak = no pagebreak on already blank pages)
		if it.level == 1 {
			pagebreak(weak: true)
		} else if heading_pagebreak_percentage != none {
			// If a heading would start at the very end of a page,
			// it would not look right => pagebreak
			context {
			  let here_abs = here().position().y
				let here_rel = here_abs.abs / page.height

				if here_rel > heading_pagebreak_percentage {
					// Write but hide to assess location correctly
					// Hidden will not have any influence
					// on the output besides correct calculation
					hide[#here_abs.abs #page.height rel: #here_rel%]
					pagebreak(weak: true)
				}
			}
		}

		[
			#set text(size: sizes.at(2))
			#v(sizes.at(0))
			#if it.numbering != none [
				#counter(heading).display(it.numbering) #h(4pt) #it.body
			] else [#it.body]
			#v(sizes.at(1))
		]
	}

	// rename level 1 headings to "Chapter", otherwise "Section"
	#set ref(supplement: it => {
		if it.func() == heading {
			if it.level == 1 {
				selected_lang.chapter
			} else {
				selected_lang.section
			}
		} else {
			it.supplement
		}
	})

	// ==========================
        // beginning of the document
        // ==========================

        // ==========================
        // Start of the title pages
        // ==========================

	#set align(center)

	// nice
	#grid(
		columns: (1fr),
                        align(center)[
			#image(university.image, width: 69%)
		],
	)
	#v(64pt)

	#set par(justify: false)
	#text(20pt)[*#title*]
	#v(32pt)
	#set par(justify: true)

	#text(16pt)[*#type*]
	//#v(14pt)

	//#text(14pt, selected_lang.degree_1)

	//#text(14pt)[*#degree*]

	//#text(14pt)[#selected_lang.degree_2 #major]
	//#v(32pt)

	#text(14pt, selected_lang.by)

	#text(16pt)[*#author*]
	#v(16pt)

	#text(14pt)[#date.display("[day].[month].[year]")]

	#set align(bottom)

	#grid(
		columns: (1fr, 0.5fr, 1fr),
		align(left)[
			//*#selected_lang.time_period* \
			//*#selected_lang.student_id* \
			*#selected_lang.supervisor* \
                        *#selected_lang.first_referee* \
                        *#selected_lang.second_referee*
		],
		none,
		align(left)[
			//#time_period \
			//#student_id \
			#supervisor \
                        #first_referee \
                        #second_referee
		],
	)

	#pagebreak()
	#set align(top)
	#set align(left)
        // End of title page

	// initially set the page numbering to roman
	#set page(numbering: "I")
	#counter(page).update(1)

        // ==========================
        // Sworn Declaration
        // ==========================

       	#set align(top)
	#set align(start)

	#(selected_lang.decleration)(type, title)
	
        #set align(bottom)
	// #v(48pt)

	// #university.location, #date.display("[day].[month].[year]")
	// #v(48pt)

	#box(width: 196pt, height: 40pt)[
		#if signature == "hide" {
			box(height: 50pt)
		} else if signature == none {
			[
				Set your signature by setting the `signature` argument
				to an image or set it to `hide`, to leave place for signing otherwise
				#v(2pt)
			]
		} else {
			image(signature)
		}
		#v(0pt, weak: true)
		#line(length: 100%)
		// #author
                #university.location, #date.display("[day].[month].[year]")

	]

        #v(48pt)

	#pagebreak()

        // end of sworn declaration
        
        // ==========================
        // Abstract
        // ==========================

	#set align(horizon)
	#set align(center)

	#heading(outlined: true, selected_lang.abstract)

	#block(width: 80%)[
		#set align(left)
		#abstract
	]

	#pagebreak()

        // End of abstract
        

        #set align(top)
        #set align(left)
	#set outline(
		indent: n => {
			// Max indent is 2
			if n > 2 { n = 2 }
			return n * 2em
		},
	)
	#show outline.entry.where(level: 1): it => {
		if it.element.func() != heading { return it }
		// show ".": ""
		v(2pt)
		strong(it)
	}

	#outline(target: heading, depth: 2, title: selected_lang.contents)

	// start adding headings to the outline after the table of contents
	#set heading(outlined: true)

	#pagebreak(weak: true)

	= #selected_lang.list_of_figures

	#show outline.entry: it => [
		#v(12pt, weak: true) #it
	]

	#outline(target: figure, title: none)

	#pagebreak(weak: true)

	= #selected_lang.acronyms

	#let acroArr = ();
	#for (k, v) in acronyms.pairs().sorted(key: s => lower(s.at(0))) {
		acroArr.push([*#k* #label(k)]);
		acroArr.push([#v]);
	}

	#table(
		columns: (1fr, 6fr),
		align: horizon,
		stroke: none,
		..acroArr,
	)

	// this will be used later to continue the Roman counter for pages where it left off
	<roman_counter_preliminary_end>
	// update heading and page numberings to begin the main part of the document
	#set heading(numbering: "1.1")
	#set page(
		numbering: "1 / 1",
		// manipulate the footer to display the correct total page count
		// otherwise it would show the value of the very last, Roman-numbered page
		footer: align(center, context numbering(
			"1 / 1",
			..counter(page).get(),
			// get the last page counted with Arabic numbers
			..counter(page).at(<arabic_counter_end>).map(i => i - 1))
		)
	)
	#counter(page).update(1)

	#pagebreak(weak: true)

	// Format code blocks
	#show raw.where(block: true): set align(left)
	#show raw.where(block: true): set par(justify: false)
	#show raw.where(block: true): set text(size: 8pt)
	#show raw.where(block: true): set block(
	  radius: 2pt,
	  inset: 12pt,
	  width: 100%,
	  stroke: luma(128),
	  fill: luma(240),
	)

	// the actual chapters
	#body

	// reset footer to how it looked before
	#set page(numbering: "I", footer:
		align(center, context numbering("I", ..counter(page).get()))
	)
	// reset the page numberings to the following value of the last page counted in Roman numerals
	#context counter(page).update(
	  counter(page).at(<roman_counter_preliminary_end>).first() + 1
	)
	// used to obtain the total page count of Arabic numbered pages
	<arabic_counter_end> // Placing this above does not work

	// finally, include the bibliography chapter at the end of the document
	#pagebreak()
	#bibliography(bibliography_path, title: selected_lang.bibliography,
		style: if customized_ieee_citations {"/ieee-modified.csl"} else {"ieee"})

	#if appendix != none [
		#pagebreak(weak: true)
		#heading(numbering: none, selected_lang.appendix)
		#set heading(
			outlined: true,
			bookmarked: true,
			numbering: (..nums) => {
				let n = nums.pos()
				n.remove(0)
				return numbering("A.1", ..n)
			}
		)
		#appendix
	]
]

// `pref` if to prefer the long form
// may be normal, short or long
#let acro(short, pref: "normal", append: "") = {
	let item = acronyms.at(short)

	context {
	let entries = acroStates.at(here()).filter(e => e == short);

	// Already used once
	if entries.len() > 0 {
		if pref == "long" {
			link(label(short))[#item#append]
		} else {
			link(label(short))[#short#append]
		}
	// First usage
	} else {
		acroStates.update(e => {e.push(short); e;});
		if pref == "short" {
			link(label(short))[#short#append (#item)]
		} else {
			link(label(short))[#item#append (#short)]
		}
	}
	}
}

#let acroOnce(main, inside) = [#main (#inside)]

#let todo(content) = par(emph([
	#h(5pt) #text(weight: "bold")[To-do/WIP:] #content
]))
