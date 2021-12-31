%
% LaTeX document class for creating Posters according to the TUG   Poster Style
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
% v0.97 (xx/11/2017)
%    - NEW: additional content block: 3 coloums with background color and optional background image (top)
%    - NEW: allow different page sizes: A0, A1, 70x100 as document options
%    - NEW: allow specifying relative height/widht using \IPTRelHeight \IPTRelWidth 
%           (e.g., picture scales with size of poster)
% v0.96 (04/09/2014)
%    - NEW: additional document option 'frame=Xmm'
%           shifts institute logo to the left to accountfor space consumed by potential frame
% v0.95 (26/08/2014)
%    - IMPR: text justified, itemized list RaggedRight
%    - IMPR: loading babel (english)
%    - NEW: print version information for print-ready posters (cropmarks enabled)
%    - IMPR: flushleft author names (aviods hypenations)
%
% v0.94 (25/08/2014)
%    - IMPR: added space before nested itemized list
%    - IMPR: moved line below block titles slightly down
%
% v0.9 (20/08/2014)
%    - bugfix / hack that some block borders show up when resizing the page
%    - NEW: document option to create PDF with cropmarks (and cutting border)
%    - NEW: automatic placement of sponsor/partner logos in the footer.
%           add partnerlogos with 'IPTpartner' before  \begin{document}
%           (previous variant IPTpartners is still available for special purposes)
%    - NEW: typeset references automatically either twocolumn or threecolumn,
%           depending on the text-width

\def\tugPoster{tug\textit{Poster}}
\def\tugPosterVersion{v0.97}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tugPoster}[2018/04/03 \tugPosterVersion LaTeX document class for Posters]

\RequirePackage[cmyk]{xcolor}
\RequirePackage{xkeyval}
\RequirePackage{ifthen}
\RequirePackage{qrcode}

\newif\ifIPT@debug
\newif\ifIPT@cropmarks
\newif\ifIPT@croprectangle
\newlength{\IPTFrameMargin}


\newcommand{\IPT@size}{a0}
\DeclareOptionX{debug}{\IPT@debugtrue}
\DeclareOptionX{cropmarks}{\IPT@cropmarkstrue}
\DeclareOptionX{croprectangle}{\IPT@cropmarkstrue\IPT@croprectangletrue}
\DeclareOptionX{frame}[0mm]{\setlength\IPTFrameMargin{#1}}
\DeclareOptionX*{\PackageWarning{tugPoster}{‘\CurrentOption’ ignored}}
\define@choicekey*{tugPoster.cls}{size}[\val\nr]{A0,A1,70x100}[a0]{
	\renewcommand{\IPT@size}{\val}
}

\ProcessOptionsX


\ifthenelse{\equal{\IPT@size}{a0}}{
	\LoadClass[fontsize=36pt]{scrartcl}
	\usepackage{scrlayer-scrpage}
}{}
\ifthenelse{\equal{\IPT@size}{a1}}{
	\LoadClass[fontsize=26pt,scrpage2]{scrartcl}
	\usepackage{scrlayer-scrpage}
}{}
\ifthenelse{\equal{\IPT@size}{70x100}}{
	\LoadClass[fontsize=30pt,scrpage2]{scrartcl}
	\usepackage{scrlayer-scrpage}
}{}

\RequirePackage{geometry}
\RequirePackage[english]{babel}
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{helvet}
\RequirePackage{multicol}
\RequirePackage{enumitem}
\RequirePackage[skins]{tcolorbox}
\RequirePackage{calc}
\RequirePackage{tikz}
%\RequirePackage{graphicx}
\RequirePackage{adjustbox}
\RequirePackage{datetime}
\RequirePackage{xspace}
\RequirePackage{ragged2e}

\@ifpackagelater{tcolorbox}{2014/05/18}{%
    % Package is new enough
}{%
    \ClassError{tugPoster}{Package tcolorbox is to old! Required vesion is 3.0.4}{%
    	Update!
    }
}
\@ifpackagelater{tikz}{2013/12/13}{%
    % Package is new enough
}{%
    \ClassError{tugPoster}{Package tikz is to old! Required vesion is 3.0.0}{%
    	Update!
    }%
}

    \usetikzlibrary{shapes,decorations,shadows,backgrounds,calc,fadings,fit}
    \usetikzlibrary{decorations.pathmorphing}
    \usepgflibrary{arrows.meta}



\newlength{\IPTPageWidth}
\newlength{\IPTPageHeight}
\newlength{\IPTMarginLeft}
\newlength{\IPTMarginRight}
\newlength{\IPTMarginTop}
\newlength{\IPTMainColsGap}
\newlength{\IPTContentColsGap}
\newlength{\IPTHeaderHeight}
\newlength{\IPTFooterHeight}
\newlength{\IPTFooterQRWidth}

\newlength{\IPTCropMargin}
\newlength{\IPTContentWidth}
\newlength{\IPTColumnWidth}

\newlength{\IPT@cropmarkspace}\setlength{\IPT@cropmarkspace}{3mm}

\ifthenelse{\equal{\IPT@size}{a0}}{
		\setlength{\IPTPageWidth}{841mm}
		\setlength{\IPTPageHeight}{1189mm}

		\setlength{\IPTMarginLeft}{82mm}
		\setlength{\IPTMarginRight}{24mm}
		\setlength{\IPTMarginTop}{86mm}
		\setlength{\IPTHeaderHeight}{83mm}
		\setlength{\IPTFooterHeight}{138mm}
		\setlength{\IPTMainColsGap}{30mm}
		\setlength{\IPTContentColsGap}{24mm}
		\setlength{\IPTFooterQRWidth}{60mm}
}{}
\ifthenelse{\equal{\IPT@size}{a1}}{
		\setlength{\IPTPageWidth}{594mm}
		\setlength{\IPTPageHeight}{841mm}

		\setlength{\IPTMarginLeft}{58mm}
		\setlength{\IPTMarginRight}{16mm}
		\setlength{\IPTMarginTop}{60mm}
		\setlength{\IPTHeaderHeight}{58mm}
		\setlength{\IPTFooterHeight}{98mm}
		\setlength{\IPTMainColsGap}{21mm}
		\setlength{\IPTContentColsGap}{16mm}
		\setlength{\IPTFooterQRWidth}{42mm}
}{}
\ifthenelse{\equal{\IPT@size}{70x100}}{
		\setlength{\IPTPageWidth}{700mm}
		\setlength{\IPTPageHeight}{1000mm}

		\setlength{\IPTMarginLeft}{70mm}
		\setlength{\IPTMarginRight}{20mm}
		\setlength{\IPTMarginTop}{72.5mm}
		\setlength{\IPTHeaderHeight}{70mm}
		\setlength{\IPTFooterHeight}{116mm}
		\setlength{\IPTMainColsGap}{25mm}
		\setlength{\IPTContentColsGap}{20mm}
		\setlength{\IPTFooterQRWidth}{50mm}
}{}

\newlength{\IPTRelWidth}\setlength{\IPTRelWidth}{0.01\IPTPageWidth}
\newlength{\IPTRelHeight}\setlength{\IPTRelHeight}{0.01\IPTPageHeight}

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
% ####

\newlength{\IPT@HeaderInstituteFontSize}
\newlength{\IPT@HeaderAddressFontSize}
\newlength{\IPT@FooterNoteFontSize}
\newlength{\IPT@FooterURLFontSize}

\newlength{\IPT@TitleRulerShift}\setlength{\IPT@TitleRulerShift}{3.5mm}

\newkomafont{itemize1}{}
\newkomafont{itemize2}{}
\newkomafont{itemize3}{}
\newkomafont{figurecaption}{}
\newkomafont{abstract}{}
\newkomafont{referencestitle}{}
\newkomafont{references}{}
\newkomafont{citation}{}
\newkomafont{authorname}{}
\newkomafont{authoraffiliation}{}
\newkomafont{authoremail}{}

\newkomafont{cropmarkannotation}{\fontsize{14pt}{1em}\selectfont}
\ifthenelse{\equal{\IPT@size}{a0}}{
	\setkomafont{title}{\fontsize{86pt}{103.2pt}\selectfont\bfseries}
	\setkomafont{subtitle}{\fontsize{78}{93.6}\selectfont\bfseries}
	\setkomafont{section}{\fontsize{58pt}{69.6pt}\selectfont\bfseries}
	\setkomafont{subsection}{\fontsize{46}{55.2}\selectfont\bfseries}
	\setkomafont{itemize1}{\fontsize{36pt}{43.2}\selectfont}
	\setkomafont{itemize2}{\fontsize{32pt}{38.4pt}\selectfont}
	\setkomafont{itemize3}{\fontsize{28.8pt}{34.6pt}\selectfont}
	\setkomafont{figurecaption}{\fontsize{24pt}{28.8pt}\selectfont}

	\setkomafont{abstract}{\fontsize{28.8pt}{34.6pt}\selectfont}
	\setkomafont{referencestitle}{\fontsize{36pt}{38.4}\selectfont\bfseries}
	\setkomafont{references}{\fontsize{16.8pt}{20.2pt}\selectfont}
	\setkomafont{citation}{\fontsize{21.6pt}{26pt}\selectfont}

	\setkomafont{authorname}{\fontsize{34pt}{1em}\selectfont}
	\setkomafont{authoraffiliation}{\fontsize{32pt}{1em}\selectfont}
	\setkomafont{authoremail}{\fontsize{28.8pt}{1em}\selectfont}

	\RedeclareSectionCommand[beforeskip=0.5\baselineskip,afterskip=1\baselineskip]{subsection}
	\setlength{\IPT@HeaderInstituteFontSize}{28pt}
	\setlength{\IPT@HeaderAddressFontSize}{26pt}
	\setlength{\IPT@FooterNoteFontSize}{21.5pt}
	\setlength{\IPT@FooterURLFontSize}{31pt}
}{}
\ifthenelse{\equal{\IPT@size}{a1}}{
	\setkomafont{title}{\fontsize{72pt}{94pt}\selectfont\bfseries}
	\setkomafont{subtitle}{\fontsize{66}{79.2}\selectfont\bfseries}
	\setkomafont{section}{\fontsize{48pt}{57.6pt}\selectfont\bfseries}
	\setkomafont{subsection}{\fontsize{38}{45.6}\selectfont\bfseries}
	\setkomafont{itemize1}{\fontsize{26pt}{31.2}\selectfont}
	\setkomafont{itemize2}{\fontsize{22.5pt}{27pt}\selectfont}
	\setkomafont{itemize3}{\fontsize{22pt}{26.4pt}\selectfont}
	\setkomafont{figurecaption}{\fontsize{16pt}{19.2pt}\selectfont}

	\setkomafont{abstract}{\fontsize{20pt}{24pt}\selectfont}
	\setkomafont{referencestitle}{\fontsize{25pt}{30pt}\selectfont\bfseries}
	\setkomafont{references}{\fontsize{11.6pt}{14pt}\selectfont}
	\setkomafont{citation}{\fontsize{15pt}{18pt}\selectfont}

	\setkomafont{authorname}{\fontsize{24pt}{1em}\selectfont}
	\setkomafont{authoraffiliation}{\fontsize{22pt}{1em}\selectfont}
	\setkomafont{authoremail}{\fontsize{20pt}{1em}\selectfont}

	\RedeclareSectionCommand[beforeskip=0.5\baselineskip,afterskip=1\baselineskip]{subsection}
	\setlength{\IPT@HeaderInstituteFontSize}{24pt}
	\setlength{\IPT@HeaderAddressFontSize}{22pt}
	\setlength{\IPT@FooterNoteFontSize}{18pt}
	\setlength{\IPT@FooterURLFontSize}{26pt}

}{}
\ifthenelse{\equal{\IPT@size}{70x100}}{
	\setkomafont{title}{\fontsize{72pt}{94pt}\selectfont\bfseries}
	\setkomafont{subtitle}{\fontsize{66}{79.2}\selectfont\bfseries}
	\setkomafont{section}{\fontsize{48pt}{57.6pt}\selectfont\bfseries}
	\setkomafont{subsection}{\fontsize{38}{45.6}\selectfont\bfseries}
	\setkomafont{itemize1}{\fontsize{30pt}{36pt}\selectfont}
	\setkomafont{itemize2}{\fontsize{26pt}{31.2pt}\selectfont}
	\setkomafont{itemize3}{\fontsize{24pt}{28.8pt}\selectfont}
	\setkomafont{figurecaption}{\fontsize{18pt}{21.6pt}\selectfont}

	\setkomafont{abstract}{\fontsize{24pt}{28.8pt}\selectfont}
	\setkomafont{referencestitle}{\fontsize{30pt}{36pt}\selectfont\bfseries}
	\setkomafont{references}{\fontsize{14pt}{16.8pt}\selectfont}
	\setkomafont{citation}{\fontsize{18pt}{21.6pt}\selectfont}

	\setkomafont{authorname}{\fontsize{28pt}{1em}\selectfont}
	\setkomafont{authoraffiliation}{\fontsize{26pt}{1em}\selectfont}
	\setkomafont{authoremail}{\fontsize{24pt}{1em}\selectfont}

	\RedeclareSectionCommand[beforeskip=0.5\baselineskip,afterskip=1\baselineskip]{subsection}
	% \setkomafont{subsubsection}{\singlespacing\fontsize{42}{50.4}\selectfont\bfseries}
	% \setkomafont{normal}{\fontsize{30pt}{36pt}\selectfont}
	% \fontsize{30pt}{36pt}\selectfont
	\setlength{\IPT@HeaderInstituteFontSize}{24pt}
	\setlength{\IPT@HeaderAddressFontSize}{22pt}
	\setlength{\IPT@FooterNoteFontSize}{18pt}
	\setlength{\IPT@FooterURLFontSize}{26pt}
}{}


\definecolor{TUG_red}{cmyk}{0,.96,.57,0}
\@ifundefinedcolor{IPTInstituteColor}{
	\definecolor{IPTInstituteColor}{cmyk}{0,.96,.57,0}
}

\@ifundefinedcolor{IPTHeaderColor}{
	\definecolor{IPTHeaderColor}{cmyk}{.90,.52,.17,.02}
}


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
	flushleft upper,
	flushleft lower,
	valign=top,
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
		coltitle=IPTHeaderColor,
		size=minimal,
		boxsep=0pt,
		arc=0pt,
		left=0pt,
		right=0pt,
		top=3mm,
		toptitle=8mm,
		bottomtitle=3mm,
		bottom=5mm,
		title code={\path[draw=IPTHeaderColor,solid,line width=5pt] ([yshift=\IPT@TitleRulerShift]title.south west) -- ([yshift=\IPT@TitleRulerShift]title.south east);},
		flushleft title,
		%flushleft upper,
		fonttitle=\usekomafont{subtitle},
		box align=top,
	}
}
\tcbset{
	poster_figure/.style={
		enhanced,
		frame hidden,
		interior empty,
		interior titled empty,
		segmentation hidden,
		coltitle=IPTHeaderColor,
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
		fontlower=\usekomafont{figurecaption}\itshape,
		box align=top,
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
	%\justify
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
% #### content block with 3 columns and background color and background image
% ####

\def\IPT@cThreeColorA{}
\def\IPT@cThreeColorB{}
\def\IPT@cThreeColorC{}
\define@key{IPTcolorBlock}{color1}{\def\IPT@cThreeColorA{#1}}
\define@key{IPTcolorBlock}{color2}{\def\IPT@cThreeColorB{#1}}
\define@key{IPTcolorBlock}{color3}{\def\IPT@cThreeColorC{#1}}

\def\IPT@cThreeImageA{}
\def\IPT@cThreeImageB{}
\def\IPT@cThreeImageC{}
\newif\ifIPT@cThreeHasImage
\define@key{IPTcolorBlock}{image1}{\IPT@cThreeHasImagetrue\def\IPT@cThreeImageA{#1}}
\define@key{IPTcolorBlock}{image2}{\IPT@cThreeHasImagetrue\def\IPT@cThreeImageB{#1}}
\define@key{IPTcolorBlock}{image3}{\IPT@cThreeHasImagetrue\def\IPT@cThreeImageC{#1}}


\newlength{\IPT@cThreeImageHeight}
\define@key{IPTcolorBlock}{imageHeight}{\setlength{\IPT@cThreeImageHeight}{#1}}

\newenvironment{IPTcolorBlock3}[2][]{
	\setkeys{IPTcolorBlock}{#1}
	\renewcommand{\IPTcolbreak}{
			\end{minipage}%
			\end{center}
			\vfill\null
		\columnbreak
			\begin{center}
			\begin{minipage}{\columnwidth-\colpadding}
	}
	\vspace{-5mm}
	\newlength{\colpadding}\setlength{\colpadding}{10mm}
	\fboxsep0pt
	\begin{tcolorbox}[
		poster_content,
		poster_content_debug,
		adjusted title={#2},
		interior titled code={
			\ifx\IPT@cThreeColorA\empty\else
		    \fill[\IPT@cThreeColorA]
		    	let \p1 = ($ (interior.north west)!1/3!(interior.north east)$),
		    		\p9 = (interior.south)
		    	in 
				([yshift=\IPT@TitleRulerShift]interior.north west) rectangle (\x1, \y9);
			\fi
		    \ifx\IPT@cThreeColorB\empty\else
		    \fill[\IPT@cThreeColorB]
		    	let \p2 = ($ (interior.north west)!1/3!(interior.north east)$),
		    		\p3 = ($ (interior.north west)!2/3!(interior.north east)$),
		    		\p9 = (interior.south)
		    	in 
				([yshift=\IPT@TitleRulerShift]\x2, \y3) rectangle (\x3, \y9);
			\fi
			\ifx\IPT@cThreeColorC\empty\else
		    \fill[\IPT@cThreeColorC]
		    	let \p4 = ($ (interior.north west)!2/3!(interior.north east)$)
		    	in 
				([yshift=\IPT@TitleRulerShift]\x4, \y4) rectangle (interior.south east);
			\fi
			\ifx\IPT@cThreeImageA\empty\else
			\path[fill overzoom image=\IPT@cThreeImageA]
		    	let \p1 = (interior.north west),
		    		\p9 = ($ (interior.north west)!1/3!(interior.north east)$)
		    	in 
				([yshift=\IPT@TitleRulerShift]\x1, \y1) rectangle ([yshift=-\IPT@cThreeImageHeight+\IPT@TitleRulerShift]\x9, \y9);
			\fi
			\ifx\IPT@cThreeImageB\empty\else
			\path[fill overzoom image=\IPT@cThreeImageB]
		    	let \p2 = ($ (interior.north west)!1/3!(interior.north east)$),
		    		\p9 = ($ (interior.north west)!2/3!(interior.north east)$)
		    	in 
				([yshift=\IPT@TitleRulerShift]\x2, \y2) rectangle ([yshift=-\IPT@cThreeImageHeight+\IPT@TitleRulerShift]\x9, \y9);
			\fi
			\ifx\IPT@cThreeImageC\empty\else
				\path[fill overzoom image=\IPT@cThreeImageC]
		    	let \p2 = ($ (interior.north west)!2/3!(interior.north east)$),
		    		\p9 = (interior.north east)
		    	in 
				([yshift=\IPT@TitleRulerShift]\x2, \y2) rectangle ([yshift=-\IPT@cThreeImageHeight+\IPT@TitleRulerShift]\x9, \y9);
			\fi
	},
	]
		\ifIPT@cThreeHasImage\vspace{\IPT@cThreeImageHeight}\fi
		\setlength{\columnsep}{0mm}
		\setlength{\multicolsep}{0mm}

		\begin{multicols}{3}
			\begin{center}
			\begin{minipage}{\columnwidth-\colpadding}
}
{
			\end{minipage}
			\end{center}
			\vfill\null
		\end{multicols}
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
	fontupper=\usekomafont{abstract},
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
	title code={\path[draw=IPTHeaderColor,solid,line width=4pt] ([yshift=2.25mm]title.south west) -- ([yshift=2.25mm]title.south east);},
	flushleft title,
	fonttitle=\usekomafont{referencestitle},
	fontupper=\usekomafont{references},
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
\tcbset{
	poster_twocol/.style={
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
	}
}

\newtcolorbox{IPTtwocol}{
	poster_twocol,
	sidebyside align=top,
	poster_twocolumn_debug,
}

% ####
% ####  Box for two-column content within an IPTblock, gap=5mm (content)
% ####
\tcbset{
	poster_cols/.style={
		enhanced,
		frame hidden,
		interior empty,
		interior titled empty,
		segmentation hidden,
		boxsep=0pt,
		arc=0pt,
		left=0pt,
		right=0pt,
		top=-1em+3mm,
		%top=0mm,
		toptitle=0mm,
		sidebyside,
		sidebyside align=top,
		sidebyside gap=5mm,
		middle=0mm,
		box align=top,
		%baseline=1em,
		enlarge top initially by=1em,
	}
}
\newtcolorbox{IPTcols}[1]{
	poster_cols,
	sidebyside align=top,
	lefthand ratio=#1,
	poster_column_debug,
}



%########################################################################################
%########################################################################################
%########################################################################################

% ####
% #### define aliases or other handy commands/environments
% ####

\newcommand{\IPTcolbreak}{\tcblower}

\newcommand{\IPTcite}[1]{{\usekomafont{citation}#1}}

\newcommand{\IPTsection}[1]{\section*{#1}\vspace{-0.5em}}

\newcommand{\IPTsubsection}[1]{\subsection*{#1}\vspace{-0.5em}}

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
	        \usekomafont{authorname}\textbf{\@authorNameA} \\[7mm]
	        \ifx\@authorAffiliationA\empty\else\usekomafont{authoraffiliation}{\@authorAffiliationA} \\[2mm]\fi
	        \ifx\@authorEmailA\empty\else\usekomafont{authoremail}\textit{\@authorEmailA}\fi
        \fi
		\tcblower

		\ifx\@authorNameB\empty\else
	        \usekomafont{authorname}\textbf{\@authorNameB} \\[7mm]
	        \ifx\@authorAffiliationB\empty\else\usekomafont{authoraffiliation}{\@authorAffiliationB} \\[2mm]\fi
	        \ifx\@authorEmailB\empty\else\usekomafont{authoremail}\textit{\@authorEmailB}\fi
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
	label=\tikz{\path[fill=TUG_red,rounded corners=0pt] (0,0) rectangle (5.953mm,5.953mm);},
	before=\usekomafont{itemize1}\RaggedRight,
	after=\justifying
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
	label=\tikz{\path[fill=black!55,rounded corners=0pt] (0,0) rectangle (5.159mm,5.159mm);},
	before=\usekomafont{itemize2}
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
	label=\tikz{\path[fill=black!40,rounded corners=0pt] (0,0) rectangle (4.763mm,4.763mm);},
	before=\usekomafont{itemize3}
}

%########################################################################################
%########################################################################################
%########################################################################################

% ####
% #### generating the poster layout. TUG header, institute logo, QR code, separator lines etc.
% ####   heavily uses tikz for positioning all elements. 
% #### IMPORTANT: this code assumes a poster size of 700x1000 mm!

\newif\ifIPT@showQR
\IPT@showQRtrue
\newcommand{\NoQRCode}{\IPT@showQRfalse}

\newif\ifIPT@showNFC
\IPT@showNFCfalse
\newcommand{\ShowNFC}{\IPT@showNFCtrue}

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

\newcommand{\IPTInstituteName}[1]{\def\IPT@instituteName{#1}}
\newcommand{\IPTInstituteAddress}[1]{\def\IPT@instituteAddress{#1}}
\newcommand{\IPTInstituteShort}[1]{\def\IPT@instituteShort{#1}}
\newcommand{\IPTInstituteBanner}[1]{\def\IPT@instituteLogo{#1}}
\newcommand{\IPTInstituteURL}[2][]{\def\IPT@instituteURL{#2}\def\IPT@qrUrl{#1}}
\newcommand{\IPTInstituteEmail}[1]{\def\IPT@instituteEmail{#1}}

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

% ###
% ### Define a command to draw all poster layout elements in a tikzpicture
% ###

\newlength{\IPT@footerWidth}\setlength{\IPT@footerWidth}{\IPTPageWidth-\IPTMarginLeft-\IPTMarginRight}
\newcommand{\IPT@Page}{
		\begin{tikzpicture}[remember picture,overlay]
		\node (IPTpage) at (current page) [rectangle,inner sep=0pt,minimum width=\IPTPageWidth,minimum height=\IPTPageHeight] {};
		\node[anchor=north west,outer sep=0,inner sep=0] (IPTheader) at ([xshift=\IPTMarginLeft]IPTpage.north west) [rectangle,inner sep=0,minimum width=\IPTPageWidth-\IPTMarginLeft-\IPTMarginRight,minimum height=\IPTHeaderHeight] {};

		\node[anchor=south west,outer sep=0,inner sep=0] (IPTfooter) at ([xshift=\IPTMarginLeft]IPTpage.south west) [rectangle,inner sep=0,minimum width=\IPTPageWidth-\IPTMarginLeft-\IPTMarginRight,minimum height=\IPTFooterHeight] {};

		\ifIPT@croprectangle
			\path [draw,line width=0.25pt] (IPTpage.north west) rectangle (IPTpage.south east);
		\fi
		\ifIPT@cropmarks

			\draw [line width=0.25pt] ([xshift=-\IPT@cropmarkspace]IPTpage.north west) -- +(-\IPTCropMargin,0);
			\draw [line width=0.25pt] ([yshift= \IPT@cropmarkspace]IPTpage.north west) -- +(0,\IPTCropMargin);
			\draw [line width=0.25pt] ([xshift= \IPT@cropmarkspace]IPTpage.north east) -- +( \IPTCropMargin,0);
			\draw [line width=0.25pt] ([yshift= \IPT@cropmarkspace]IPTpage.north east) -- +(0,\IPTCropMargin);

			\draw [line width=0.25pt] ([xshift=-\IPT@cropmarkspace]IPTpage.south west) -- +(-\IPTCropMargin,0);
			\draw [line width=0.25pt] ([yshift=-\IPT@cropmarkspace]IPTpage.south west) -- +(0,-\IPTCropMargin);
			\draw [line width=0.25pt] ([xshift= \IPT@cropmarkspace]IPTpage.south east) -- +( \IPTCropMargin,0);
			\draw [line width=0.25pt] ([yshift=-\IPT@cropmarkspace]IPTpage.south east) -- +(0,-\IPTCropMargin);

			\node [font=\usekomafont{cropmarkannotation},anchor=south east] at ([xshift=-10mm,yshift=3mm]IPTpage.north east) {Created by \LaTeX\xspace using \tugPoster\xspace \tugPosterVersion\xspace by M. Quaritsch};

			\node [font=\usekomafont{cropmarkannotation},anchor=south] at ([yshift=3mm]IPTpage.north) {Page Size: \MakeUppercase{\IPT@size}};


			\node [font=\usekomafont{cropmarkannotation},anchor=south west] at ([xshift=3mm,yshift=3mm]IPTpage.north west) {{\jobname}.pdf \quad \yyyymmdddate\today \quad \currenttime};

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

		% ##
		% ##  HEADER
		% ##
		% line at header
        \node[anchor=north west,outer sep=0,inner sep=0,yshift=-0.9\IPTHeaderHeight,fill=white] (top_separator) at (IPTheader.north west) {
                \begin{tikzpicture}
                        \draw [line width=1pt] (0,0) -- (\IPTPageWidth-\IPTMarginLeft-\IPTMarginRight,0);
                \end{tikzpicture}
            };
        % TUG logo and claim (en)
	    \node[anchor=north east, yshift=-0.23\IPTHeaderHeight,outer sep=0,inner sep=0] (tug_claim) at (IPTheader.north east)
	        {\includegraphics[height=0.6\IPTHeaderHeight]{Logo-und-Claim-englisch-CMYK_crop}};
	    % Institute name and address
	    \node[below left,node distance=0,outer sep=0,inner sep=0] (institute_coordinates) at (IPTheader.south east)
	        { {\fontsize{\IPT@HeaderInstituteFontSize}{1em}\selectfont\textbf{\IPT@instituteName}}
	          \begin{tikzpicture}\path [fill=gray] (0,0) rectangle (0.6776\IPT@HeaderAddressFontSize,0.6776\IPT@HeaderAddressFontSize);\end{tikzpicture} %
	          {\fontsize{\IPT@HeaderAddressFontSize}{1em}\selectfont \IPT@instituteAddress}
	          \begin{tikzpicture}\path [fill=gray] (0,0) rectangle (0.6776\IPT@HeaderAddressFontSize,0.6776\IPT@HeaderAddressFontSize);\end{tikzpicture}
	           {\fontsize{\IPT@HeaderAddressFontSize}{1em}\selectfont\textit{\IPT@instituteEmail}}
	        };

	    % ##
		% ## institute logo on the left side
		% ##
	    \node[anchor=north east, yshift=-1.2\IPTHeaderHeight,xshift=0.75\IPTMarginLeft+\IPTFrameMargin,outer sep=0,inner sep=0] (institute_logo) at (IPTpage.north west)
	        {
	         \ifx\IPT@instituteLogo\undefined
	        	\begin{tikzpicture}
        			\path [fill=IPTInstituteColor, anchor=north west] (0,0) rectangle (-0.85\IPTHeaderHeight,-0.75\IPTHeaderHeight);
        			\node [rotate=90] (institute_short) at (-0.72\IPTHeaderHeight,-0.78\IPTHeaderHeight) {\fontsize{\IPTHeaderHeight}{1em}\fontfamily{ugq}\selectfont\color{black!35!white}\uppercase\expandafter{\IPT@instituteShort}};
	        	\end{tikzpicture}
	         \else
	        	\includegraphics[width=0.85\IPTHeaderHeight]{\IPT@instituteLogo}
	         \fi
	         };

		% ##
		% ##  FOOTER
		% ##
	    % footer line
	    \node[anchor=north west,outer sep=0,inner sep=0] (bot_separator) at (IPTfooter.north west) {
	    	\begin{tikzpicture}
	    		\draw [line width=1pt] (0,0) -- (\IPTPageWidth-\IPTMarginLeft-\IPTMarginRight,0);
	    	\end{tikzpicture}
	    };
	    \ifIPT@showQR
	    % footer content: QR/NFC
	    \node[anchor=east,outer sep=0,inner sep=0] (nfc_qr) at (IPTfooter.east) {
	        \begin{tikzpicture}
	        	\ifIPT@showNFC
	        		\node[anchor=north east,outer sep=0,inner sep=0] (nfc) at (0,0) {
		                \includegraphics[width=\IPTFooterQRWidth]{QR_NFC}
		            };
		            \node[anchor=north east,outer sep=0,inner sep=0] (qr_code) at (0,0) {
		            \ifx\IPT@qrUrl\empty
		                \qrcode[height=\IPTFooterQRWidth]{http://\IPT@instituteURL}
		            \else
		                %\includegraphics[width=\IPTFooterQRWidth,trim={2.5mm 2.5mm 3mm 2.5mm}]{\theQRCode}
		                \qrcode[height=\IPTFooterQRWidth]{\IPT@qrUrl}
	            	\fi
		            };
		            \node[anchor=north east,outer sep=0,inner sep=0,rotate=90]{
		                {\fontsize{\IPT@FooterURLFontSize}{1em}\selectfont\textbf{\IPT@instituteURL}\,\,}
		            };
	        	\else
		            \node[anchor=north east,yshift=-10mm,outer sep=0,inner sep=0] (qr_code) at (0,0) {
		            \ifx\IPT@qrUrl\empty
		                \qrcode[height=\IPTFooterQRWidth]{http://\IPT@instituteURL}
		            \else
%		                \includegraphics[width=\IPTFooterQRWidth,trim={2.5mm 2.5mm 3mm 2.5mm}]{\theQRCode}
		                \qrcode[height=\IPTFooterQRWidth]{\IPT@qrUrl}
	            	\fi
		            };
		            \node[anchor=north east,outer sep=0,inner sep=0,rotate=90]{
		                {\fontsize{\IPT@FooterURLFontSize}{1em}\selectfont\textbf{\IPT@instituteURL}\,\,}
		            };
	            \fi
	        \end{tikzpicture}
	    };
	    \fi
	    % \newlength{\IPT@footerWidth}\setlength{\IPT@footerWidth}{\IPTPageWidth-\IPTMarginLeft-\IPTMarginRight}

	    % footer content: partner logos
		\ifnum\theIPT@partnerCount=0
		    \node[anchor=north west, outer sep=0,inner sep=0,yshift=-0.18\IPTFooterHeight] (partners) at (IPTfooter.north west) {
	    		\begin{minipage}{0.88\IPT@footerWidth}
	    				\IPT@partnersCustom
				\end{minipage}
		    };
		\else
		    \node[anchor=north west, outer sep=0,inner sep=0,xshift=0.05\IPT@footerWidth,yshift=-0.18\IPTFooterHeight] (partners) at (IPTfooter.north west) {
	    		\begin{minipage}{0.79\IPT@footerWidth}
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
	    \node[anchor=north west, outer sep=0,inner sep=0,yshift=-0.1\IPTFooterHeight] (partners) at (IPTfooter.north west) {
    		\begin{minipage}{0.88\IPT@footerWidth}
    			\fontsize{\IPT@FooterNoteFontSize}{1.2\IPT@FooterNoteFontSize}\selectfont
		    	\IPT@partnersNote
    		\end{minipage}
	    };
	\end{tikzpicture}
}

% #############################################################################

% ### Declare a new pagelayout and add a new layer with the layout elements of the poster

\DeclareLayer[background,head,contents={\IPT@Page}]{IPTPosterPageLayout}

\defpagestyle{iptposter}{{}{}{}}{{}{}{}}
\AddLayersToPageStyle{iptposter}{IPTPosterPageLayout}

\AtBeginDocument{
	\pagestyle{iptposter}
}

\makeatother
