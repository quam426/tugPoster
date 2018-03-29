%
% LaTeX document class for creating Posters according to the TUG ITI Poster Style
%
% Original code by Markus Quaritsch 2014
%
% This file may be distributed and/or modified
%
% 1. under the LaTeX Project Public License and/or
% 2. under the GNU Public License.
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  CHANGELOG
%
% v0.9 (20/08/2014)
%    - bugfix / hack that some block borders show up when resizing the page
%    - NEW: document option to create PDF with cropmarks (and cutting border)
%    - NEW: automatic placement of sponsor/partner logos in the footer. 
%           add partnerlogos with 'IPTpartner' before  \begin{document}
%           (previous variant IPTpartners is still available for special purposes)
%    - NEW: typeset references automatically either twocolumn or threecolumn, 
%           depending on the text-width



\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tugPoster}[2014/08/25 v0.94 LaTeX document class for Posters]

\RequirePackage[cmyk]{xcolor}
\RequirePackage{xkeyval}

\newif\ifIPT@debug
\newif\ifIPT@cropmarks

\DeclareOptionX{debug}{\IPT@debugtrue}
\DeclareOptionX{cropmarks}{\IPT@cropmarkstrue}
\DeclareOptionX*{\PackageWarning{tugPoster}{‘\CurrentOption’ ignored}}

\ProcessOptionsX

\LoadClass[fontsize=30pt]{scrartcl}

\RequirePackage{geometry}
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{helvet}
\RequirePackage{multicol}
\RequirePackage{enumitem}
\RequirePackage[skins]{tcolorbox}
\RequirePackage{calc}
\RequirePackage{ifthen}
\RequirePackage{tikz}
%\RequirePackage{graphicx}
\RequirePackage{adjustbox}
\RequirePackage{datetime}

    \usetikzlibrary{shapes,decorations,shadows,backgrounds,calc,fadings,fit}
    \usetikzlibrary{decorations.pathmorphing}
    \usepgflibrary{arrows}

\newlength{\IPTPageWidth}
\newlength{\IPTPageHeight}
\newlength{\IPTCropMargin}
\newlength{\IPTMarginLeft}
\newlength{\IPTMarginRight}
\newlength{\IPTMarginTop}
\newlength{\IPTMainColsGap}
\newlength{\IPTContentColsGap}
\newlength{\IPTContentWidth}
\newlength{\IPTColumnWidth}

\setlength{\IPTPageWidth}{700mm}
\setlength{\IPTPageHeight}{1000mm}
\setlength{\IPTMarginLeft}{70mm}
\setlength{\IPTMarginRight}{20mm}
\setlength{\IPTMarginTop}{72.5mm}
\setlength{\IPTMainColsGap}{25mm}
\setlength{\IPTContentColsGap}{20mm}

\setlength{\IPTContentWidth}{\IPTPageWidth-\IPTMarginLeft-\IPTMarginRight}
\setlength{\IPTColumnWidth}{0.5\IPTContentWidth-0.5\IPTMainColsGap}

\ifIPT@cropmarks
\setlength{\IPTCropMargin}{15mm}
\fi

\geometry{
	paperwidth=\IPTPageWidth+2\IPTCropMargin,
	paperheight=\IPTPageHeight+2\IPTCropMargin,
	lmargin=\IPTMarginLeft+\IPTCropMargin,
	rmargin=\IPTMarginRight+\IPTCropMargin,
	tmargin=\IPTMarginTop+\IPTCropMargin,
	% bmargin=120mm,
	ignorehead, ignorefoot, nohead, nofoot, ignoremp,
}


% \makeatletter

\renewcommand*{\familydefault}{\sfdefault}

% ####
% #### definition of font sizes and colors used in the poster
% ####   IMPORTANT: font size is for poster of size 700x1000 mm!

\setkomafont{title}{\fontsize{72pt}{94pt}\selectfont\bfseries}
\setkomafont{subtitle}{\fontsize{66}{79.2}\selectfont\bfseries}
\setkomafont{section}{\fontsize{48pt}{57.6pt}\selectfont\bfseries}
\setkomafont{subsection}{\singlespacing\fontsize{42}{50.4}\selectfont\bfseries}
% \setkomafont{subsubsection}{\singlespacing\fontsize{42}{50.4}\selectfont\bfseries}
% \setkomafont{normal}{\fontsize{30pt}{36pt}\selectfont}

\definecolor{TUG_red}{cmyk}{0,.96,.57,0}
\definecolor{ITI_blue}{cmyk}{.90,.52,.17,.02}


%########################################################################################
%########################################################################################
%########################################################################################

% ####
% #### block for typesetting the poster title, only used internally in maketitle
% ####
\newtcolorbox{IPTposterheader}[2][]{
	enhanced,
	frame hidden,
	interior empty,
	interior titled empty,
	% lowerbox=ignored,
	segmentation hidden,
	coltitle=black,
	size=minimal,
	boxsep=0pt,
	arc=0pt,
	left=0pt,
	right=0pt,
	top=0mm,
	toptitle=0mm,
	bottomtitle=5mm,
	bottom=5mm,
	sidebyside,
	sidebyside align=top,
	sidebyside gap=\IPTMainColsGap,
	fonttitle=\usekomafont{title},
 	adjusted title=#2,
	poster_header_debug,#1
 }

% ####
% ####  Default tcolorbox settings for content blocks
% ####    large title (blue), line below title, spacings, etc.
\tcbset{
	poster_content/.style={
		enhanced,
		frame hidden,
		interior empty,
		interior titled empty,
		segmentation hidden,
		lowerbox=ignored,
		coltitle=ITI_blue,
		size=minimal,
		boxsep=0pt,
		arc=0pt,
		left=0pt,
		right=0pt,
		top=3mm,
		toptitle=8mm,
		bottomtitle=3mm,
		bottom=5mm,
		title code={\path[draw=ITI_blue,solid,line width=5pt] ([yshift=3.5mm]title.south west) -- ([yshift=3.5mm]title.south east);},
		flushleft title,
		flushleft upper,
		fonttitle=\usekomafont{subtitle},
	}
}
\tcbset{
	poster_figure/.style={
		enhanced,
		frame hidden,
		interior empty,
		interior titled empty,
		segmentation hidden,
		coltitle=ITI_blue,
		size=minimal,
		boxsep=3mm,
		arc=0pt,
		left=0pt,
		right=0pt,
		top=0mm,
		toptitle=0mm,
		bottomtitle=0mm,
		bottom=0mm,
		center upper,
		center lower,
		notitle,
		fontlower=\fontsize{18pt}{21.6pt}\selectfont\itshape,
	}
}

\ifIPT@debug
	\tcbset{
		poster_content_debug/.style={
			show bounding box=red,
			segmentation style={double=white!90!red,draw=red,
                          double distance=20mm,solid}
		}
	}
	\tcbset{
		poster_column_debug/.style={
			show bounding box=green,
			segmentation style={double=white!90!green,draw=green,
                          double distance=5mm,solid}
		}
	}
	\tcbset{
		poster_twocolumn_debug/.style={
			show bounding box=green,
			segmentation style={double=white!90!green,draw=green,
                          double distance=25mm,solid}
		}
	}
	\tcbset{
		poster_header_debug/.style={
			show bounding box=blue,
			segmentation style={double=white!90!blue,draw=blue,
                          double distance=25mm,solid}
        }
	}
	\tcbset{
		poster_figure_debug/.style={
			show bounding box=magenta,
		}
	}
\else
	\tcbset{ poster_content_debug/.style={} }
	\tcbset{ poster_column_debug/.style={} }
	\tcbset{ poster_twocolumn_debug/.style={} }
	\tcbset{ poster_header_debug/.style={} }
	\tcbset{ poster_figure_debug/.style={} }
\fi

% ####
% #### basic content block with additional arguments for typesetting content in two columns.
% ####
\def\IPT@twocols{}
\define@key{IPTcontentblock}{twocol}[0.5]{%
  \def\IPT@twocols{#1}
}

\newenvironment{IPTblock}[2][]{
	\setkeys{IPTcontentblock}{#1}
	\ifx\IPT@twocols\empty
		\begin{tcolorbox}[
			poster_content,
			poster_content_debug,
			adjusted title={#2}
		]
	\else
		\begin{tcolorbox}[
			poster_content,
			lowerbox=visible,
			sidebyside,
			sidebyside align=top,
			sidebyside gap=\IPTContentColsGap,
			adjusted title={#2},
			lefthand ratio=\IPT@twocols,
			poster_content_debug,
		]
	\fi
}{
	\end{tcolorbox}
}

% ####
% #### command for placing figures
% ####

\def\IPT@graphics@options{}
\def\IPT@graphics@caption{}
\def\IPT@graphics@label{}
\define@key{IPTfigureblock}{caption}[]{\def\IPT@graphics@caption{#1}}
\define@key{IPTfigureblock}{imgoptions}[]{\def\IPT@graphics@options{#1}}
\define@key{IPTfigureblock}{label}[]{\def\IPT@graphics@label{#1}}

\newcommand{\IPTgraphics}[2][]{%
	\def\IPT@graphics@options{}
	\def\IPT@graphics@caption{}
	\def\IPT@graphics@label{}
	\setkeys{IPTfigureblock}{#1}
	\begin{tcolorbox}[
		poster_figure,
		poster_figure_debug,
		label=\IPT@graphics@label,
	]
		\expandafter\includegraphics\expandafter[\IPT@graphics@options]{#2}
		\ifx\IPT@graphics@caption\empty\else
		\IPTcolbreak
		\IPT@graphics@caption
		\fi
	\end{tcolorbox}
}

% ####
% ####  block for setting the abstract. smaller font, text justified
% ####
\newtcolorbox{IPTabstractblock}[1]{
	poster_content,
	poster_content_debug,
	before upper = ,
	fontupper=\fontsize{24pt}{28.8pt}\selectfont,
	adjusted title={#1}
}

% ####
% ####  block for setting the references. smaller title, smaller font for content
% ####
\newtcolorbox{IPT@refsblock}[1]{
	poster_content,
	poster_content_debug,
	left=3mm,
	right=3mm,
	bottomtitle=4mm,
	title code={\path[draw=ITI_blue,solid,line width=4pt] ([yshift=2.25mm]title.south west) -- ([yshift=2.25mm]title.south east);},
	flushleft title,
	fonttitle=\fontsize{30pt}{36pt}\selectfont\bfseries,
	fontupper=\fontsize{14pt}{16.8pt}\selectfont,
	adjusted title={#1}
}

\newenvironment{IPTrefsblock}[1]{
	\ifdim\textwidth<0.5\IPTPageWidth
		\setlist*[refs]{
		  before=\setlength{\columnsep}{5mm}\setlength{\multicolsep}{0pt}\vskip-8mm\begin{multicols}{2},
		  after=\end{multicols}
		}
	\else
		\setlist*[refs]{
		  before=\setlength{\columnsep}{5mm}\setlength{\multicolsep}{0pt}\vskip-8mm\begin{multicols}{3},
		  after=\end{multicols}
		}
	\fi
	\begin{IPT@refsblock}{#1}
}{
	\end{IPT@refsblock}
}

% ####
% #### Box for having IPTblocks typeset in two-column layout, gap=25mm (whole poster)
% ####
\newtcolorbox{IPTtwocol}{
	enhanced,
	frame hidden,
	interior empty,
	interior titled empty,
	segmentation hidden,
	boxsep=0pt,
	arc=0pt,
	left=0pt,
	right=0pt,
	top=0mm,
	toptitle=0mm,
	sidebyside,
	sidebyside align=top,
	sidebyside gap=\IPTMainColsGap,
	middle=0mm,
	poster_twocolumn_debug,
}

% ####
% ####  Box for two-column content within an IPTblock, gap=5mm (content)
% ####
\newtcolorbox{IPTcols}[1]{
	enhanced,
	frame hidden,
	interior empty,
	interior titled empty,
	segmentation hidden,
	boxsep=0pt,
	arc=0pt,
	left=0pt,
	right=0pt,
	top=0mm,
	toptitle=0mm,
	sidebyside,
	sidebyside align=top,
	sidebyside gap=5mm,
	lefthand ratio=#1,
	middle=0mm,
	poster_column_debug,
}


%########################################################################################
%########################################################################################
%########################################################################################

% ####
% #### define aliases or other handy commands/environments
% ####

\newcommand{\IPTcolbreak}{\tcblower}

\newcommand{\IPTcite}[1]{{\fontsize{18pt}{21.6pt}\selectfont#1}}

\newcommand{\IPTsection}[1]{\section*{#1}\vskip-12mm}

\newcommand{\bs}{\textbackslash}   % backslash

%########################################################################################
%########################################################################################
%########################################################################################

% ####
% #### redefine `maketitle' to create poster header. authors can be one or two columns
% ####

% \newcommand{\inserttitle}{~}
\renewcommand{\title}[1]{\def\inserttitle{#1}}

\def\@authorNameA{}
\def\@authorNameB{}
\def\@authorAffiliationA{}
\def\@authorAffiliationB{}
\def\@authorEmailA{}
\def\@authorEmailB{}
\newcommand{\authorNameA}[1]{\def\@authorNameA{#1}}
\newcommand{\authorAffiliationA}[1]{\def\@authorAffiliationA{#1}}
\newcommand{\authorEmailA}[1]{\def\@authorEmailA{#1}}
\newcommand{\authorNameB}[1]{\def\@authorNameB{#1}}
\newcommand{\authorAffiliationB}[1]{\def\@authorAffiliationB{#1}}
\newcommand{\authorEmailB}[1]{\def\@authorEmailB{#1}}

% @@@ TODO: make author list either single column or 2/3 columns (argument for maketitle?)
\renewcommand\maketitle[1][]{  % #1 keys
	\def\title@additionalparams{}
	\ifx\@authorNameB\empty\def\title@additionalparams{lowerbox=ignored}\fi
     \ifx\@authorNameB\empty
     	\begin{IPTposterheader}[lowerbox=ignored,sidebyside=false]{\inserttitle}
 	\else
     	\begin{IPTposterheader}{\inserttitle}
 	\fi
     	\ifx\@authorNameA\empty\else
	        \fontsize{28pt}{1em}\selectfont\textbf{\@authorNameA} \\[7mm]
	        \ifx\@authorAffiliationA\empty\else\fontsize{26pt}{1em}\selectfont{\@authorAffiliationA} \\[2mm]\fi
	        \ifx\@authorEmailA\empty\else\fontsize{24pt}{1em}\selectfont\textit{\@authorEmailA}\fi
        \fi
		\tcblower

		\ifx\@authorNameB\empty\else
	        \fontsize{28pt}{1em}\selectfont\textbf{\@authorNameB} \\[7mm]
	        \ifx\@authorAffiliationB\empty\else\fontsize{26pt}{1em}\selectfont{\@authorAffiliationB} \\[2mm]\fi
	        \ifx\@authorEmailB\empty\else\fontsize{24pt}{1em}\selectfont\textit{\@authorEmailB}\fi
        \fi
     \end{IPTposterheader}
}

%########################################################################################
%########################################################################################
%########################################################################################

% ####
% #### define custom enumeration list `refs' (enumitem), allow typesetting either in two or thre columns
% ####
\newlist{refs}{enumerate}{1}
\setlist[refs]{
	label=[\arabic{refsi}],
	labelindent=0mm,
	itemindent=0mm,
	leftmargin=10mm,
	rightmargin=0mm,
	topsep=0mm,
	partopsep=0mm,
	parsep=0mm,
	itemsep=0.5mm,
%    after=\end{multicols}
}


%%% ###
%%% ### DEPRECATED: number of columns is automatically determined depending on line width!
%%% ###
%%% \SetEnumitemKey{twocol}{
%%%   before=\setlength{\columnsep}{5mm}\setlength{\multicolsep}{0pt}\vskip-8mm\begin{multicols}{2},
%%%   after=\end{multicols}
%%% }
%%% \SetEnumitemKey{threecol}{
%%%   before=\setlength{\columnsep}{5mm}\setlength{\multicolsep}{0pt}\vskip-8mm\begin{multicols}{3},
%%%   after=\end{multicols}
%%% }
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ####
% #### define itemized lists up to nesting level 3
% ####   custom bullet points, indent, font size
\setitemize[1]{
	leftmargin=12mm,
	labelindent=0mm,
	itemindent=0mm,
	labelsep=*,
	itemsep=2mm,
	topsep=0mm,
	partopsep=0mm,
	parsep=0mm,
	label=\tikz{\path[fill=TUG_red] (0,0) rectangle (5.953mm,5.953mm);}
}
\setitemize[2]{
	leftmargin=12mm,
	labelindent=0mm,
	itemindent=0mm,
	labelsep=*,
	itemsep=2mm,
	topsep=3mm,
	partopsep=0mm,
	parsep=0mm,
	label=\tikz{\path[fill=black!55] (0,0) rectangle (5.159mm,5.159mm);},
	before=\fontsize{26pt}{31.2pt}\selectfont
}
\setitemize[3]{
	leftmargin=12mm,
	labelindent=0mm,
	itemindent=0mm,
	labelsep=*,
	itemsep=2mm,
	topsep=2mm,
	partopsep=0mm,
	parsep=0mm,
	label=\tikz{\path[fill=black!40] (0,0) rectangle (4.763mm,4.763mm);},
	before=\fontsize{24pt}{28.8pt}\selectfont
}

%########################################################################################
%########################################################################################
%########################################################################################

% ####
% #### generating the poster layout. TUG header, institute logo, QR code, separator lines etc.
% ####   heavily uses tikz for positioning all elements. 
% #### IMPORTANT: this code assumes a poster size of 700x1000 mm!

\def\theQRCode{QR-iti}
\newcommand{\QRCode}[1]{\def\theQRCode{#1}}


\def\IPT@partnerlogo@options{}
\define@key{IPTpartnerlogo}{imgoptions}[]{\def\IPT@partnerlogo@options{#1}}

%\newcommand{\IPTgraphics}[2][]{%
%	\setkeys{IPTfigureblock}{#1}
%	\begin{tcolorbox}[
%		poster_figure,
%		poster_figure_debug,
%		label=\IPT@graphics@label,
%	]
%		\expandafter\includegraphics\expandafter[\IPT@graphics@options]{#2}
%		\ifx\IPT@graphics@caption\empty\else
%		\IPTcolbreak
%		\IPT@graphics@caption
%		\fi
%	\end{tcolorbox}
%}

\newcounter{IPT@partnerCount}
\def\IPT@partnersCustom{}
\newcommand*{\IPT@partners}{}
\def\IPT@partnersNote{}
\newcommand{\IPTpartnersNote}[1]{\def\IPT@partnersNote{#1}}
\newcommand{\IPTpartners}[1]{\def\IPT@partnersCustom{#1}}

\newcommand{\IPTpartner}[2][]{%
	\stepcounter{IPT@partnerCount}
	\g@addto@macro\IPT@partners{
		\def\IPT@partnerlogo@options{}
		\setkeys{IPTpartnerlogo}{#1}
		\ifnum\theIPT@partnerCount>1
			\columnbreak
		\fi
		\null\vfill\maxsizebox*{\columnwidth}{50mm}{
			\adjustbox{valign=M,\ifIPT@debug frame\fi}{
				\expandafter\includegraphics\expandafter[\IPT@partnerlogo@options]{#2}
			}
		}\vfill\null
	}
}


%########################################################################################


\AtBeginDocument{
	\thispagestyle{empty}
	\begin{tikzpicture}[remember picture,overlay]
		\node (IPTpage) at (current page) [rectangle,inner sep=0pt,minimum width=\IPTPageWidth,minimum height=\IPTPageHeight] {};
		\ifIPT@cropmarks
			\path [draw,line width=0.25pt] (IPTpage.north west) rectangle (IPTpage.south east);
			\draw [line width=0.25pt] ([xshift=-3mm]IPTpage.north west) -- +(-\IPTCropMargin,0);
			\draw [line width=0.25pt] ([yshift= 3mm]IPTpage.north west) -- +(0,\IPTCropMargin);
			\draw [line width=0.25pt] ([xshift= 3mm]IPTpage.north east) -- +( \IPTCropMargin,0);
			\draw [line width=0.25pt] ([yshift= 3mm]IPTpage.north east) -- +(0,\IPTCropMargin);

			\draw [line width=0.25pt] ([xshift=-3mm]IPTpage.south west) -- +(-\IPTCropMargin,0);
			\draw [line width=0.25pt] ([yshift=-3mm]IPTpage.south west) -- +(0,-\IPTCropMargin);
			\draw [line width=0.25pt] ([xshift= 3mm]IPTpage.south east) -- +( \IPTCropMargin,0);
			\draw [line width=0.25pt] ([yshift=-3mm]IPTpage.south east) -- +(0,-\IPTCropMargin);

			\node [font=\fontsize{14pt}{1em}\selectfont,anchor=south west] at ([xshift=3mm,yshift=3mm]IPTpage.north west) {{\jobname}.pdf \quad \yyyymmdddate\today \quad \currenttime};

			\node[anchor=north] (colorbar) at ([xshift=-8mm,yshift=-15mm]IPTpage.north west) {
				\begin{tikzpicture}
					\path [draw=white,fill=black,line width=2pt]   (0,0)  rectangle +(0.9,0.9);
					\path [draw=white,fill=yellow,line width=2pt]  (0,-1) rectangle +(0.9,0.9);
					\path [draw=white,fill=red,line width=2pt]     (0,-2) rectangle +(0.9,0.9);
					\path [draw=white,fill=magenta,line width=2pt] (0,-3) rectangle +(0.9,0.9);
					\path [draw=white,fill=blue,line width=2pt]    (0,-4) rectangle +(0.9,0.9);
					\path [draw=white,fill=cyan,line width=2pt]    (0,-5) rectangle +(0.9,0.9);
					\path [draw=white,fill=green,line width=2pt]   (0,-6) rectangle +(0.9,0.9);
					\path [draw=white,fill=cyan!50,line width=2pt]    (0,-7) rectangle  +(0.9,0.9);
					\path [draw=white,fill=magenta!50,line width=2pt] (0,-8) rectangle  +(0.9,0.9);
					\path [draw=white,fill=yellow!50,line width=2pt]  (0,-9) rectangle  +(0.9,0.9);
					\path [draw=white,fill=black!50,line width=2pt]   (0,-10) rectangle +(0.9,0.9);
				\end{tikzpicture}
			};
			\node[anchor=west] (graybar) at ([xshift=3mm,yshift=-8mm]IPTpage.south west) {
				\begin{tikzpicture}
					\path [draw=white,fill=black!100,line width=2pt]  (0,0) rectangle +(0.9,0.9);
					\path [draw=white,fill=black!90, line width=2pt] (1,0) rectangle +(0.9,0.9);
					\path [draw=white,fill=black!80, line width=2pt] (2,0) rectangle +(0.9,0.9);
					\path [draw=white,fill=black!70, line width=2pt] (3,0) rectangle +(0.9,0.9);
					\path [draw=white,fill=black!60, line width=2pt] (4,0) rectangle +(0.9,0.9);
					\path [draw=white,fill=black!50, line width=2pt] (5,0) rectangle +(0.9,0.9);
					\path [draw=white,fill=black!40, line width=2pt] (6,0) rectangle +(0.9,0.9);
					\path [draw=white,fill=black!30, line width=2pt] (7,0) rectangle +(0.9,0.9);
					\path [draw=white,fill=black!20, line width=2pt] (8,0) rectangle +(0.9,0.9);
					\path [draw=white,fill=black!10, line width=2pt] (9,0) rectangle +(0.9,0.9);
				\end{tikzpicture}
			};
		\fi
        \node[anchor=north west,outer sep=0,inner sep=0,xshift=70mm,yshift=-63mm,fill=white] (top_separator) at (IPTpage.north west) {
                \begin{tikzpicture}
                        \draw [line width=1pt] (0,0) -- (610mm,0);
                \end{tikzpicture}
            };
	    \node[anchor=north west, yshift=-85mm,outer sep=0,inner sep=0] (iti_logo) at (IPTpage.north west)
	        {\includegraphics[width=52mm]{img/kurz_iti}};
	    \node[anchor=north east, xshift=-20mm,yshift=-16mm,outer sep=0,inner sep=0] (tug_claim) at (IPTpage.north east)
	        {\includegraphics[height=42mm]{img/Logo-und-Claim-englisch-CMYK_crop}};
	    \node[below left,xshift=-20mm,yshift=-70mm,node distance=0,outer sep=0,inner sep=0] (iti_coordinates) at (IPTpage.north east)
	        { {\fontsize{24pt}{1em}\selectfont\textbf{Institute for Technical Informatics}}
	          \begin{tikzpicture}\path [fill=gray] (0,0) rectangle (4.763mm,4.763mm);\end{tikzpicture} %
	          {\fontsize{22pt}{1em}\selectfont Inffeldgasse 16/I, 8010 Graz, Austria}
	          \begin{tikzpicture}\path [fill=gray] (0,0) rectangle (4.763mm,4.763mm);\end{tikzpicture}
	           {\fontsize{22pt}{1em}\selectfont\textit{office@iti.tugraz.at}}
	        };
	    \node[anchor=north west,outer sep=0,inner sep=0,xshift=70mm,yshift=116mm] (top_separator) at (IPTpage.south west) {
	    	\begin{tikzpicture}
	    		\draw [line width=1pt] (0,0) -- (610mm,0);
	    	\end{tikzpicture}
	    };
	    \node[anchor=north east,outer sep=0,inner sep=0,xshift=-20mm,yshift=105mm] (nfc_qr) at (IPTpage.south east) {
	        \begin{tikzpicture}
	            \node[anchor=north east,outer sep=0,inner sep=0] (nfc) at (0,0) {
	                \includegraphics[height=78mm]{img/QR_NFC}
	            };
	            \ifx\theQRCode\empty\else
	            \node[anchor=north east,outer sep=0,inner sep=0] (qr_code) at (0,0) {
	                \includegraphics[height=50mm,trim={2.5mm 2.5mm 3mm 2.5mm}]{\theQRCode}
	            };
	            \fi
	            \node[anchor=north east,outer sep=0,inner sep=0,rotate=90]{
	                {\fontsize{26pt}{1em}\selectfont\textbf{www.iti.tugraz.at}\,\,}
	            };
	        \end{tikzpicture}
	    };
		\ifnum\theIPT@partnerCount=0
		    \node[anchor=north west, outer sep=0,inner sep=0,xshift=70mm,yshift=95mm] (partners) at (IPTpage.south west) {
	    		\begin{minipage}{540mm}
	    				\IPT@partnersCustom
				\end{minipage}
		    };
		\else
		    \node[anchor=north west, outer sep=0,inner sep=0,xshift=100mm,yshift=95mm] (partners) at (IPTpage.south west) {
	    		\begin{minipage}{480mm}
	    			\ifnum\theIPT@partnerCount=1
	    				\centering
	    				\IPT@partners
	    			\else
						\setlength{\columnsep}{5mm}\setlength{\multicolsep}{0pt}
						\ifIPT@debug
							\setlength{\columnseprule}{1pt}
						\fi
						\begin{multicols}{\theIPT@partnerCount}
							\centering
				    		\IPT@partners
			    		\end{multicols}
			    	\fi
				\end{minipage}
		    };
    	\fi
	    \node[anchor=north west, outer sep=0,inner sep=0,xshift=70mm,yshift=105mm] (partners) at (IPTpage.south west) {
    		\begin{minipage}{540mm}
    			\fontsize{18pt}{21.6pt}\selectfont
		    	\IPT@partnersNote
    		\end{minipage}
	    };
	\end{tikzpicture}

}

\makeatother
