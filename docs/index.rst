.. figure:: https://github.com/profLewis/Geog2021_Coursework/blob/master/images/ucl_logo.png?raw=true
   :alt: UCL


Geog0027 Coursework
===================
.. GEOG0027 Coursework documentation master file, created by
   sphinx-quickstart on Tue Jan 15 12:17:06 2019.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.


Course Tutors
-------------

`Prof. P. Lewis`_

`Prof. M. Disney`_

`Dr Qingling Wu`_

Department of Geography

University College London


Welcome to GEOG0027 Coursework documentation
============================================

.. toctree::
   :numbered:
   :maxdepth: 3
   :caption: Contents:

   Introduction <CW-1-Pearl-River-Intro.ipynb>
   
   ENVI Setup <Running_ENVI_on_your_own_computer.ipynb>
   Modelling Setup <Rsetup.ipynb>
   Google Download <DownloadEE.ipynb>
   
   Classification <CW-1-PearlRiver-Class.ipynb>
   Modelling <2021_UrbanModel.ipynb>
   
   Project Write up <WriteUp.ipynb>
   Project Advice <Project_Advice.ipynb>

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`


Accessing the notes via github
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The notes are available on
`github <https://github.com/profLewis/Geog0027_Coursework>`__. You can
directly download the notes from
`github <https://github.com/profLewis/Geog0027_Coursework>`__, either
using some ```git`` <http://en.wikipedia.org/wiki/Git_(software)>`__
software, e.g:

::

   bash% mkdir -p ~/DATA
   bash% cd ~/DATA
   bash% git clone https://github.com/profLewis/Geog0027_Coursework.git

or by downloading the `course notes as a zip
file <https://github.com/profLewis/Geog0027_Coursework/archive/master.zip>`__.

If you use ``git``, you can apply any updates to the notes:

::

   bash% mkdir -p ~/DATA
   bash% cd ~/DATA/Geog2021_Coursework
   bash% git reset --hard HEAD
   bash% git pull

You can also fork the notes and create your own version.

Using the notes for Geog 0027
-----------------------------

You can of course just read and digest the html notes, but you will find
that there are snippets of computer code (in Python) at times. Note that
you **do not** need to use the Python codes to do this coursework: you
can do everything you need in ENVI and Excel. 

Running ipython notebooks to use the notes for Geog 0027
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In many ways a better approach is to use the ipython notebooks:

::

   bash% mkdir -p ~/DATA
   bash% cd ~/DATA/Geog2021_Coursework

Then start a browser (e.g. firefox, safari etc) and start a
[``jupyter notebook``] session:

``bash% jupyter notebook``

This should open a page in your browser, e.g.
``http://localhost:8889/tree``

If you then e.g. click on the link
```DownloadEE.ipynb`` <http://localhost:8889/notebooks/DownloadEE.ipynb>`__,
this should run the notebook in a new tab in the browser.

You can now go through the notes, and run (and/or edit) the python (and bash) codes
as they appear on the page.

The various images, text etc. are in ‘cells’ on the web page. To ‘run’ a
cell select the cursor in that cell and then either do ``Shift Return``
(i.e. Shift and Return keys at the same time), or click the ‘play’
button.


.. _Prof. P. Lewis: http://www2.geog.ucl.ac.uk/~plewis
.. _Prof. M. Disney: http://www2.geog.ucl.ac.uk/~mdisney
.. _Dr Qingling Wu: https://www.geog.ucl.ac.uk/people/research-staff/qingling-wu

