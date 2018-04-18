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
% v0.98 (17/04/18)
%    - NEW: adding IPTtikz command to add TikZ pictures
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
\def\tugPosterVersion{v0.98}

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
}{}
\ifthenelse{\equal{\IPT@size}{a1}}{
	\LoadClass[fontsize=26pt]{scrartcl}
}{}
\ifthenelse{\equal{\IPT@size}{70x100}}{
	\LoadClass[fontsize=30pt]{scrartcl}
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
\def\IPT@figure@caption{}
\def\IPT@figure@label{}
\define@key{IPTgraphics}{imgoptions}[]{\def\IPT@graphics@options{#1}}
\define@key{IPTfigureblock}{caption}[]{\def\IPT@figure@caption{#1}}
\define@key{IPTfigureblock}{label}[]{\def\IPT@figure@label{#1}}

\newcommand{\IPTgraphics}[2][]{%
	\def\IPT@graphics@options{}
	\def\IPT@figure@caption{}
	\def\IPT@figure@label{}
	\setkeys{IPTfigureblock,IPTgraphics}{#1}
	\begin{tcolorbox}[
		poster_figure,
		poster_figure_debug,
		label=\IPT@figure@label,
	]
		\expandafter\includegraphics\expandafter[\IPT@graphics@options]{#2}
		\ifx\IPT@figure@caption\empty\else
		\IPTcolbreak
		\IPT@figure@caption
		\fi
	\end{tcolorbox}
}

\def\IPT@tikz@scale{1}
\def\IPT@tikz@options{}
\define@key{IPTtikz}{scale}[]{\def\IPT@tikz@scale{#1}}
\define@key{IPTtikz}{tikzoptions}[]{\def\IPT@tikz@options{#1}}
\newcommand{\IPTtikz}[2][]{
	\def\IPT@graphics@options{}
	\def\IPT@figure@caption{}
	\def\IPT@figure@label{}
	\setkeys{IPTfigureblock,IPTtikz}{#1}
	\begin{tcolorbox}[
		poster_figure,
		poster_figure_debug,
		label=\IPT@figure@label,
	]
		\begin{tikzpicture}[scale=\IPT@tikz@scale,\IPT@tikz@options]#2\end{tikzpicture}
		\ifx\IPT@figure@caption\empty\else
		\IPTcolbreak
		\IPT@figure@caption
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


\AtBeginDocument{
	\thispagestyle{empty}
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
	        {%
	        %\includegraphics[height=0.6\IPTHeaderHeight]{Logo-und-Claim-englisch-CMYK_crop}
\resizebox{!}{0.6\IPTHeaderHeight}{
\definecolor{ced1952}{cmyk}{0,.96,.57,0}
\definecolor{c231f20}{RGB}{35,31,32}
\begin{tikzpicture}[y=0.80pt, x=0.80pt, yscale=-1.000000, xscale=1.000000, inner sep=0pt, outer sep=0pt]
\begin{scope}[cm={{1.25,0.0,0.0,-1.25,(0.0,56.53688)}}]
  \path[fill=ced1952,nonzero rule] (372.6750,11.3080) -- (350.0610,11.3080) --
    (350.0610,33.9230) -- (372.6750,33.9230) -- (372.6750,11.3080) -- cycle;
  \path[fill=ced1952,nonzero rule] (397.5520,11.3080) -- (374.9380,11.3080) --
    (374.9380,33.9230) -- (397.5520,33.9230) -- (397.5520,11.3080) -- cycle;
  \path[fill=ced1952,nonzero rule] (422.4270,11.3080) -- (399.8150,11.3080) --
    (399.8150,33.9230) -- (422.4270,33.9230) -- (422.4270,11.3080) -- cycle;
  \path[fill=ced1952,nonzero rule] (361.3680,0.0000) -- (383.9840,0.0000) --
    (383.9840,22.6140) -- (361.3680,22.6140) -- (361.3680,0.0000) -- cycle;
  \path[fill=ced1952,nonzero rule] (388.5070,22.6140) -- (411.1200,22.6140) --
    (411.1200,45.2290) -- (388.5070,45.2290) -- (388.5070,22.6140) -- cycle;
  \begin{scope}[shift={(431.9316,30.2949)}]
    \path[fill=c231f20,nonzero rule] (0.0000,0.0000) -- (-7.2400,0.0000) --
      (-7.2400,3.6180) -- (11.4220,3.6180) -- (11.4220,0.0000) -- (4.1830,0.0000) --
      (4.1830,-18.9400) -- (0.0000,-18.9400) -- (0.0000,0.0000) -- cycle;
  \end{scope}
      \begin{scope}[shift={(464.334,19.6445)}]
        \path[fill=c231f20,nonzero rule] (0.0000,0.0000) .. controls (0.0000,-1.3580)
          and (-0.2430,-2.5860) .. (-0.7310,-3.6800) .. controls (-1.2210,-4.7720) and
          (-1.8870,-5.7020) .. (-2.7320,-6.4660) .. controls (-3.5770,-7.2320) and
          (-4.5740,-7.8190) .. (-5.7310,-8.2320) .. controls (-6.8870,-8.6470) and
          (-8.1420,-8.8540) .. (-9.4980,-8.8540) .. controls (-10.8520,-8.8540) and
          (-12.1060,-8.6470) .. (-13.2630,-8.2320) .. controls (-14.4190,-7.8190) and
          (-15.4250,-7.2320) .. (-16.2780,-6.4660) .. controls (-17.1350,-5.7020) and
          (-17.8020,-4.7720) .. (-18.2770,-3.6800) .. controls (-18.7570,-2.5860) and
          (-18.9940,-1.3580) .. (-18.9940,0.0000) -- (-18.9940,14.2690) --
          (-14.8110,14.2690) -- (-14.8110,0.1440) .. controls (-14.8110,-0.4070) and
          (-14.7240,-0.9850) .. (-14.5450,-1.5910) .. controls (-14.3660,-2.1940) and
          (-14.0710,-2.7520) .. (-13.6580,-3.2620) .. controls (-13.2460,-3.7710) and
          (-12.7000,-4.1880) .. (-12.0210,-4.5180) .. controls (-11.3430,-4.8460) and
          (-10.5020,-5.0110) .. (-9.4980,-5.0110) .. controls (-8.4940,-5.0110) and
          (-7.6520,-4.8460) .. (-6.9740,-4.5180) .. controls (-6.2950,-4.1880) and
          (-5.7460,-3.7710) .. (-5.3360,-3.2620) .. controls (-4.9240,-2.7520) and
          (-4.6290,-2.1940) .. (-4.4490,-1.5910) .. controls (-4.2710,-0.9850) and
          (-4.1830,-0.4070) .. (-4.1830,0.1440) -- (-4.1830,14.2690) -- (0.0000,14.2690)
          -- (0.0000,0.0000) -- cycle;
      \end{scope}
      \begin{scope}[shift={(440.8193,8.248)}]
        \path[fill=c231f20,nonzero rule] (0.0000,0.0000) .. controls (-0.8290,0.3580)
          and (-1.9030,0.5290) .. (-2.7620,0.5290) .. controls (-5.2620,0.5290) and
          (-6.6440,-1.0430) .. (-6.6440,-3.0870) .. controls (-6.6440,-5.1160) and
          (-5.2930,-6.6450) .. (-3.0080,-6.6450) .. controls (-2.4250,-6.6450) and
          (-1.9630,-6.5880) .. (-1.5960,-6.5020) -- (-1.5960,-3.9020) --
          (-3.8660,-3.9020) -- (-3.8660,-2.3290) -- (0.4600,-2.3290) -- (0.4600,-7.7030)
          .. controls (-0.6750,-7.9880) and (-1.8570,-8.2170) .. (-3.0080,-8.2170) ..
          controls (-6.4760,-8.2170) and (-8.8850,-6.6020) .. (-8.8850,-3.2300) ..
          controls (-8.8850,0.1860) and (-6.6440,2.1010) .. (-3.0080,2.1010) .. controls
          (-1.7650,2.1010) and (-0.7830,1.9440) .. (0.1370,1.6860) -- (0.0000,0.0000) --
          cycle;
      \end{scope}
      \begin{scope}[shift={(443.3955,7.5625)}]
        \path[fill=c231f20,nonzero rule] (0.0000,0.0000) -- (1.8270,0.0000) --
          (1.8270,-1.6720) -- (1.8580,-1.6720) .. controls (1.9490,-0.9860) and
          (2.7920,0.1710) .. (4.0210,0.1710) .. controls (4.2200,0.1710) and
          (4.4370,0.1710) .. (4.6490,0.1140) -- (4.6490,-1.8160) .. controls
          (4.4660,-1.7160) and (4.0990,-1.6590) .. (3.7290,-1.6590) .. controls
          (2.0580,-1.6590) and (2.0580,-3.6020) .. (2.0580,-4.6590) -- (2.0580,-7.3600)
          -- (0.0000,-7.3600) -- (0.0000,0.0000) -- cycle;
      \end{scope}
      \begin{scope}[shift={(449.6699,7.1758)}]
        \path[fill=c231f20,nonzero rule] (0.0000,0.0000) .. controls (0.7970,0.3450) and
          (1.8720,0.5590) .. (2.7480,0.5590) .. controls (5.1560,0.5590) and
          (6.1530,-0.3720) .. (6.1530,-2.5440) -- (6.1530,-3.4870) .. controls
          (6.1530,-4.2290) and (6.1690,-4.7870) .. (6.1850,-5.3300) .. controls
          (6.2000,-5.8880) and (6.2300,-6.4010) .. (6.2770,-6.9740) -- (4.4660,-6.9740)
          .. controls (4.3900,-6.5890) and (4.3900,-6.1020) .. (4.3740,-5.8730) --
          (4.3420,-5.8730) .. controls (3.8670,-6.6870) and (2.8380,-7.1450) ..
          (1.9030,-7.1450) .. controls (0.5080,-7.1450) and (-0.8580,-6.3590) ..
          (-0.8580,-4.9590) .. controls (-0.8580,-3.8580) and (-0.2920,-3.2160) ..
          (0.4920,-2.8570) .. controls (1.2750,-2.5010) and (2.2870,-2.4290) ..
          (3.1470,-2.4290) -- (4.2820,-2.4290) .. controls (4.2820,-1.2430) and
          (3.7140,-0.8430) .. (2.5020,-0.8430) .. controls (1.6280,-0.8430) and
          (0.7530,-1.1560) .. (0.0630,-1.6430) -- (0.0000,0.0000) --
          cycle(2.4100,-5.7450) .. controls (3.0390,-5.7450) and (3.5300,-5.4870) ..
          (3.8530,-5.0880) .. controls (4.1890,-4.6730) and (4.2820,-4.1440) ..
          (4.2820,-3.5720) -- (3.3930,-3.5720) .. controls (2.4730,-3.5720) and
          (1.1060,-3.7150) .. (1.1060,-4.8450) .. controls (1.1060,-5.4730) and
          (1.6730,-5.7450) .. (2.4100,-5.7450);
      \end{scope}
  \begin{scope}[shift={(457.5114,7.5627)}]
    \path[fill=c231f20,nonzero rule] (0.0000,0.0000) -- (0.0000,-1.4870) --
      (3.8350,-1.4870) -- (-0.1680,-5.8020) -- (-0.1680,-7.3600) -- (6.3990,-7.3600)
      -- (6.3990,-5.8740) -- (2.3300,-5.8740) -- (6.2600,-1.5720) -- (6.2600,0.0000)
      -- (0.0000,0.0000) -- cycle;
  \end{scope}
  \path[fill=ced1952,nonzero rule] (465.5740,0.0000) -- (473.1080,0.0000) --
    (473.1080,7.5330) -- (465.5740,7.5330) -- (465.5740,0.0000) -- cycle;
      \begin{scope}[shift={(8.7822,14.3584)}]
        \path[fill=c231f20,nonzero rule] (0.0000,0.0000) .. controls (0.0740,-1.6740)
          and (1.1500,-2.5970) .. (3.0040,-2.5970) .. controls (4.8380,-2.5970) and
          (5.9450,-1.6850) .. (5.9450,-0.2940) .. controls (5.9450,0.2940) and
          (5.7210,0.7710) .. (5.3170,1.0960) .. controls (4.8910,1.4410) and
          (4.3050,1.5630) .. (3.5590,1.7350) .. controls (1.9490,2.1030) and
          (1.2350,2.1630) .. (1.2350,3.0970) .. controls (1.2350,3.7870) and
          (1.8740,4.2640) .. (2.9190,4.2640) .. controls (4.0060,4.2640) and
          (4.6570,3.7260) .. (4.7310,2.7510) -- (5.7210,2.7510) .. controls
          (5.7100,4.2030) and (4.6780,5.0840) .. (2.9830,5.0840) .. controls
          (1.2990,5.0840) and (0.2450,4.2030) .. (0.2450,2.9240) .. controls
          (0.2450,1.6460) and (1.1180,1.2900) .. (2.8120,0.9040) .. controls
          (4.1980,0.5890) and (4.9120,0.4670) .. (4.9120,-0.4060) .. controls
          (4.9120,-1.2080) and (4.2090,-1.7350) .. (2.9940,-1.7350) .. controls
          (1.8000,-1.7350) and (1.0220,-1.0660) .. (1.0000,0.0000) -- (0.0000,0.0000) --
          cycle(17.2820,0.3050) .. controls (17.2290,-0.9230) and (16.3450,-1.7250) ..
          (15.0980,-1.7250) .. controls (13.6490,-1.7250) and (12.6580,-0.5780) ..
          (12.6580,1.2290) .. controls (12.6580,3.1270) and (13.5640,4.2030) ..
          (15.1090,4.2030) .. controls (16.2700,4.2030) and (17.0270,3.6650) ..
          (17.2180,2.7000) -- (18.2410,2.7000) .. controls (18.0710,4.1620) and
          (16.8990,5.0840) .. (15.1510,5.0840) .. controls (12.9670,5.0840) and
          (11.5940,3.6340) .. (11.5940,1.3500) .. controls (11.5940,-1.1570) and
          (12.9130,-2.6070) .. (15.0450,-2.6070) .. controls (16.9200,-2.6070) and
          (18.1990,-1.4710) .. (18.2950,0.3050) -- (17.2820,0.3050) --
          cycle(24.2310,-2.4040) -- (25.2740,-2.4040) -- (25.2740,4.8910) --
          (24.2310,4.8910) -- (24.2310,-2.4040) -- cycle(31.6370,-2.4040) --
          (37.1870,-2.4040) -- (37.1870,-1.4920) -- (32.6690,-1.4920) --
          (32.6690,0.9550) -- (36.7610,0.9550) -- (36.7610,1.8060) -- (32.6690,1.8060)
          -- (32.6690,3.9900) -- (37.1020,3.9900) -- (37.1020,4.8920) --
          (31.6370,4.8920) -- (31.6370,-2.4040) -- cycle(43.1240,-2.4040) --
          (44.1140,-2.4040) -- (44.1140,3.5120) .. controls (44.1990,3.2990) and
          (44.2950,3.1270) .. (44.4010,2.9740) -- (48.0570,-2.4040) -- (49.1860,-2.4040)
          -- (49.1860,4.8920) -- (48.1960,4.8920) -- (48.1960,-1.0250) .. controls
          (48.1110,-0.8220) and (47.9830,-0.6090) .. (47.8440,-0.4060) --
          (44.2630,4.8920) -- (43.1240,4.8920) -- (43.1240,-2.4040) --
          cycle(60.8640,0.3050) .. controls (60.8110,-0.9230) and (59.9270,-1.7250) ..
          (58.6800,-1.7250) .. controls (57.2310,-1.7250) and (56.2400,-0.5780) ..
          (56.2400,1.2290) .. controls (56.2400,3.1270) and (57.1460,4.2030) ..
          (58.6910,4.2030) .. controls (59.8520,4.2030) and (60.6090,3.6650) ..
          (60.8010,2.7000) -- (61.8230,2.7000) .. controls (61.6530,4.1620) and
          (60.4810,5.0840) .. (58.7330,5.0840) .. controls (56.5490,5.0840) and
          (55.1760,3.6340) .. (55.1760,1.3500) .. controls (55.1760,-1.1570) and
          (56.4960,-2.6070) .. (58.6270,-2.6070) .. controls (60.5020,-2.6070) and
          (61.7810,-1.4710) .. (61.8770,0.3050) -- (60.8640,0.3050) --
          cycle(67.7920,-2.4040) -- (73.3420,-2.4040) -- (73.3420,-1.4920) --
          (68.8240,-1.4920) -- (68.8240,0.9550) -- (72.9160,0.9550) -- (72.9160,1.8060)
          -- (68.8240,1.8060) -- (68.8240,3.9900) -- (73.2570,3.9900) --
          (73.2570,4.8920) -- (67.7920,4.8920) -- (67.7920,-2.4040) --
          cycle(90.0410,2.6840) -- (86.5820,2.6840) -- (86.5820,-0.7750) --
          (90.0410,-0.7750) -- (90.0410,2.6840) -- cycle(101.6060,-2.4040) --
          (102.6490,-2.4040) -- (102.6490,0.6710) -- (104.2270,0.6710) .. controls
          (105.0160,0.6710) and (105.6120,0.6810) .. (106.1030,0.9650) .. controls
          (106.7310,1.3300) and (107.0820,1.9590) .. (107.0820,2.7810) .. controls
          (107.0820,3.6450) and (106.7310,4.2940) .. (106.1130,4.6180) .. controls
          (105.6230,4.8710) and (105.0790,4.8920) .. (104.4290,4.8920) --
          (104.1520,4.8920) -- (101.6060,4.8920) -- (101.6060,-2.4040) --
          cycle(102.6490,1.5530) -- (102.6490,4.0000) -- (104.4720,4.0000) .. controls
          (105.5490,4.0000) and (106.0280,3.6850) .. (106.0280,2.7810) .. controls
          (106.0280,1.8270) and (105.5270,1.5530) .. (104.3970,1.5530) --
          (102.6490,1.5530) -- cycle(111.4140,-2.4040) -- (112.4900,-2.4040) --
          (113.3100,-0.2220) -- (116.3250,-0.2220) -- (117.1350,-2.4040) --
          (118.2640,-2.4040) -- (115.4090,4.8920) -- (114.2580,4.8920) --
          (111.4140,-2.4040) -- cycle(113.6300,0.6290) -- (114.8340,3.8470) --
          (116.0160,0.6290) -- (113.6300,0.6290) -- cycle(123.3910,0.0000) .. controls
          (123.4650,-1.6740) and (124.5400,-2.5970) .. (126.3950,-2.5970) .. controls
          (128.2290,-2.5970) and (129.3350,-1.6850) .. (129.3350,-0.2940) .. controls
          (129.3350,0.2940) and (129.1120,0.7710) .. (128.7080,1.0960) .. controls
          (128.2820,1.4410) and (127.6960,1.5630) .. (126.9490,1.7350) .. controls
          (125.3400,2.1030) and (124.6260,2.1630) .. (124.6260,3.0970) .. controls
          (124.6260,3.7870) and (125.2650,4.2640) .. (126.3100,4.2640) .. controls
          (127.3970,4.2640) and (128.0470,3.7260) .. (128.1220,2.7510) --
          (129.1120,2.7510) .. controls (129.1010,4.2030) and (128.0690,5.0840) ..
          (126.3740,5.0840) .. controls (124.6900,5.0840) and (123.6360,4.2030) ..
          (123.6360,2.9240) .. controls (123.6360,1.6460) and (124.5090,1.2900) ..
          (126.2030,0.9040) .. controls (127.5890,0.5890) and (128.3030,0.4670) ..
          (128.3030,-0.4060) .. controls (128.3030,-1.2080) and (127.6000,-1.7350) ..
          (126.3840,-1.7350) .. controls (125.1910,-1.7350) and (124.4120,-1.0660) ..
          (124.3910,0.0000) -- (123.3910,0.0000) -- cycle(135.1580,0.0000) .. controls
          (135.2330,-1.6740) and (136.3080,-2.5970) .. (138.1620,-2.5970) .. controls
          (139.9960,-2.5970) and (141.1030,-1.6850) .. (141.1030,-0.2940) .. controls
          (141.1030,0.2940) and (140.8790,0.7710) .. (140.4750,1.0960) .. controls
          (140.0490,1.4410) and (139.4630,1.5630) .. (138.7170,1.7350) .. controls
          (137.1070,2.1030) and (136.3930,2.1630) .. (136.3930,3.0970) .. controls
          (136.3930,3.7870) and (137.0320,4.2640) .. (138.0770,4.2640) .. controls
          (139.1640,4.2640) and (139.8150,3.7260) .. (139.8890,2.7510) --
          (140.8790,2.7510) .. controls (140.8680,4.2030) and (139.8360,5.0840) ..
          (138.1410,5.0840) .. controls (136.4570,5.0840) and (135.4030,4.2030) ..
          (135.4030,2.9240) .. controls (135.4030,1.6460) and (136.2760,1.2900) ..
          (137.9710,0.9040) .. controls (139.3560,0.5890) and (140.0700,0.4670) ..
          (140.0700,-0.4060) .. controls (140.0700,-1.2080) and (139.3670,-1.7350) ..
          (138.1520,-1.7350) .. controls (136.9580,-1.7350) and (136.1800,-1.0660) ..
          (136.1580,0.0000) -- (135.1580,0.0000) -- cycle(147.1030,-2.4040) --
          (148.1460,-2.4040) -- (148.1460,4.8910) -- (147.1030,4.8910) --
          (147.1030,-2.4040) -- cycle(154.1790,1.2390) .. controls (154.1790,-1.1970)
          and (155.5630,-2.6070) .. (157.8120,-2.6070) .. controls (160.0610,-2.6070)
          and (161.4340,-1.1970) .. (161.4340,1.2390) .. controls (161.4340,3.6750) and
          (160.0610,5.0840) .. (157.8120,5.0840) .. controls (155.5630,5.0840) and
          (154.1790,3.6750) .. (154.1790,1.2390)(155.2540,1.2390) .. controls
          (155.2540,3.1370) and (156.2340,4.2230) .. (157.8120,4.2230) .. controls
          (159.3890,4.2230) and (160.3590,3.1370) .. (160.3590,1.2390) .. controls
          (160.3590,-0.6590) and (159.3890,-1.7460) .. (157.8120,-1.7460) .. controls
          (156.2340,-1.7460) and (155.2540,-0.6590) ..
          (155.2540,1.2390)(167.4240,-2.4040) -- (168.4130,-2.4040) -- (168.4130,3.5120)
          .. controls (168.4990,3.2990) and (168.5950,3.1270) .. (168.7010,2.9740) --
          (172.3570,-2.4040) -- (173.4860,-2.4040) -- (173.4860,4.8920) --
          (172.4960,4.8920) -- (172.4960,-1.0250) .. controls (172.4110,-0.8220) and
          (172.2830,-0.6090) .. (172.1440,-0.4060) -- (168.5630,4.8920) --
          (167.4240,4.8920) -- (167.4240,-2.4040) -- cycle(190.5580,2.6840) --
          (187.0990,2.6840) -- (187.0990,-0.7750) -- (190.5580,-0.7750) --
          (190.5580,2.6840) -- cycle(203.8160,-2.4040) -- (204.8590,-2.4040) --
          (204.8590,4.0100) -- (207.2780,4.0100) -- (207.2780,4.8920) --
          (201.3980,4.8920) -- (201.3980,4.0100) -- (203.8160,4.0100) --
          (203.8160,-2.4040) -- cycle(212.8950,-2.4040) -- (218.4460,-2.4040) --
          (218.4460,-1.4920) -- (213.9280,-1.4920) -- (213.9280,0.9550) --
          (218.0190,0.9550) -- (218.0190,1.8060) -- (213.9280,1.8060) --
          (213.9280,3.9900) -- (218.3600,3.9900) -- (218.3600,4.8920) --
          (212.8950,4.8920) -- (212.8950,-2.4040) -- cycle(229.7510,0.3050) .. controls
          (229.6980,-0.9230) and (228.8140,-1.7250) .. (227.5670,-1.7250) .. controls
          (226.1180,-1.7250) and (225.1270,-0.5780) .. (225.1270,1.2290) .. controls
          (225.1270,3.1270) and (226.0320,4.2030) .. (227.5780,4.2030) .. controls
          (228.7390,4.2030) and (229.4960,3.6650) .. (229.6870,2.7000) --
          (230.7100,2.7000) .. controls (230.5400,4.1620) and (229.3680,5.0840) ..
          (227.6200,5.0840) .. controls (225.4360,5.0840) and (224.0620,3.6340) ..
          (224.0620,1.3500) .. controls (224.0620,-1.1570) and (225.3820,-2.6070) ..
          (227.5140,-2.6070) .. controls (229.3890,-2.6070) and (230.6680,-1.4710) ..
          (230.7640,0.3050) -- (229.7510,0.3050) -- cycle(236.6790,-2.4040) --
          (237.7220,-2.4040) -- (237.7220,1.0160) -- (241.6980,1.0160) --
          (241.6980,-2.4040) -- (242.7410,-2.4040) -- (242.7410,4.8920) --
          (241.6980,4.8920) -- (241.6980,1.8980) -- (237.7220,1.8980) --
          (237.7220,4.8920) -- (236.6790,4.8920) -- (236.6790,-2.4040) --
          cycle(249.0620,-2.4040) -- (250.0510,-2.4040) -- (250.0510,3.5120) .. controls
          (250.1360,3.2990) and (250.2320,3.1270) .. (250.3380,2.9740) --
          (253.9950,-2.4040) -- (255.1230,-2.4040) -- (255.1230,4.8920) --
          (254.1330,4.8920) -- (254.1330,-1.0250) .. controls (254.0480,-0.8220) and
          (253.9200,-0.6090) .. (253.7810,-0.4060) -- (250.2000,4.8920) --
          (249.0620,4.8920) -- (249.0620,-2.4040) -- cycle(261.1130,1.2390) .. controls
          (261.1130,-1.1970) and (262.4970,-2.6070) .. (264.7460,-2.6070) .. controls
          (266.9950,-2.6070) and (268.3680,-1.1970) .. (268.3680,1.2390) .. controls
          (268.3680,3.6750) and (266.9950,5.0840) .. (264.7460,5.0840) .. controls
          (262.4970,5.0840) and (261.1130,3.6750) .. (261.1130,1.2390)(262.1880,1.2390)
          .. controls (262.1880,3.1370) and (263.1680,4.2230) .. (264.7460,4.2230) ..
          controls (266.3230,4.2230) and (267.2930,3.1370) .. (267.2930,1.2390) ..
          controls (267.2930,-0.6590) and (266.3230,-1.7460) .. (264.7460,-1.7460) ..
          controls (263.1680,-1.7460) and (262.1880,-0.6590) ..
          (262.1880,1.2390)(274.3680,-2.4040) -- (279.2370,-2.4040) --
          (279.2370,-1.4820) -- (275.4220,-1.4820) -- (275.4220,4.8920) --
          (274.3680,4.8920) -- (274.3680,-2.4040) -- cycle(284.0320,1.2390) .. controls
          (284.0320,-1.1970) and (285.4160,-2.6070) .. (287.6650,-2.6070) .. controls
          (289.9140,-2.6070) and (291.2870,-1.1970) .. (291.2870,1.2390) .. controls
          (291.2870,3.6750) and (289.9140,5.0840) .. (287.6650,5.0840) .. controls
          (285.4160,5.0840) and (284.0320,3.6750) .. (284.0320,1.2390)(285.1070,1.2390)
          .. controls (285.1070,3.1370) and (286.0870,4.2230) .. (287.6650,4.2230) ..
          controls (289.2420,4.2230) and (290.2120,3.1370) .. (290.2120,1.2390) ..
          controls (290.2120,-0.6590) and (289.2420,-1.7460) .. (287.6650,-1.7460) ..
          controls (286.0870,-1.7460) and (285.1070,-0.6590) ..
          (285.1070,1.2390)(303.0210,-1.4310) -- (303.2440,-2.4040) --
          (303.9250,-2.4040) -- (303.9250,1.5320) -- (300.5700,1.5320) --
          (300.5700,0.7120) -- (302.9670,0.7120) -- (302.9670,0.6200) .. controls
          (302.9660,-0.8220) and (302.0190,-1.7050) .. (300.5900,-1.7050) .. controls
          (299.0230,-1.7050) and (298.0320,-0.6290) .. (298.0320,1.2700) .. controls
          (298.0320,3.1570) and (299.0020,4.2330) .. (300.6640,4.2330) .. controls
          (301.8260,4.2330) and (302.5930,3.6750) .. (302.7850,2.6900) --
          (303.7970,2.6900) .. controls (303.5730,4.1930) and (302.4120,5.0840) ..
          (300.6640,5.0840) .. controls (298.3840,5.0840) and (296.9570,3.6140) ..
          (296.9570,1.2290) .. controls (296.9570,-1.1160) and (298.4160,-2.6070) ..
          (300.4410,-2.6070) .. controls (301.5390,-2.6070) and (302.4030,-2.2120) ..
          (303.0210,-1.4310)(312.9410,-2.4040) -- (312.9410,0.5890) -- (315.6690,4.8920)
          -- (314.4430,4.8920) -- (312.4090,1.4420) -- (310.3630,4.8920) --
          (309.0530,4.8920) -- (311.8980,0.5180) -- (311.8980,-2.4040) --
          (312.9410,-2.4040) -- cycle;
      \end{scope}
\end{scope}

\end{tikzpicture}
}
	        };
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
	        		\node[anchor=center,outer sep=0,inner sep=0,yshift=-1.2\IPTFooterQRWidth,xshift=-0.55\IPTFooterQRWidth] (nfc) at (0,0) {
		                %\includegraphics[width=\IPTFooterQRWidth]{QR_NFC}
		                \resizebox{1.2\IPTFooterQRWidth}{!}{
			                \definecolor{NFC_text}{cmyk}{1,0,0,0}
							\definecolor{NFC_wave}{cmyk}{0,0,0,0.46}
							\begin{tikzpicture}
								\def\nfcRa{15mm}
								\def\nfcRb{21mm}
								\def\nfcRc{27mm}
								\def\nfcStartAngle{-37}
								\def\nfcEndAngle{37}
								\draw[NFC_wave, line width=3mm] (0mm,0mm) ++(\nfcStartAngle:\nfcRa) arc [start angle=\nfcStartAngle, end angle=\nfcEndAngle, radius=\nfcRa];
								\draw[NFC_wave, line width=3mm] (0mm,0mm) ++(\nfcStartAngle:\nfcRb) arc [start angle=\nfcStartAngle, end angle=\nfcEndAngle, radius=\nfcRb];
								\draw[NFC_wave, line width=3mm] (0mm,0mm) ++(\nfcStartAngle:\nfcRc) arc [start angle=\nfcStartAngle, end angle=\nfcEndAngle, radius=\nfcRc];
								\def\nfcStartAngle{143}
								\def\nfcEndAngle{217}
								\draw[NFC_wave, line width=3mm] (0mm,0mm) ++(\nfcStartAngle:\nfcRa) arc [start angle=\nfcStartAngle, end angle=\nfcEndAngle, radius=\nfcRa];
								\draw[NFC_wave, line width=3mm] (0mm,0mm) ++(\nfcStartAngle:\nfcRb) arc [start angle=\nfcStartAngle, end angle=\nfcEndAngle, radius=\nfcRb];
								\draw[NFC_wave, line width=3mm] (0mm,0mm) ++(\nfcStartAngle:\nfcRc) arc [start angle=\nfcStartAngle, end angle=\nfcEndAngle, radius=\nfcRc];
								\node[anchor=center] at (0,0) {\color{NFC_text}\textbf{NFC}};
							\end{tikzpicture}
		                }
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
	    \newlength{\IPT@footerWidth}\setlength{\IPT@footerWidth}{\IPTPageWidth-\IPTMarginLeft-\IPTMarginRight}

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

\makeatother
