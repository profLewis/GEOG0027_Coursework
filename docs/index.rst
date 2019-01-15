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
   Download <Download.ipynb>
   Classification <CW-1-PearlRiver-Class.ipynb>
   Modelling <2021_UrbanModel.ipynb>
   Project Write up <WriteUp.ipynb>
   Project Advice <Project_Advice.ipynb>

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`


Coursework notes for Geog 0027
------------------------------

Accessing a test dataset
~~~~~~~~~~~~~~~~~~~~~~~~

Whilst you will need to order and download the data yourselves in this
practical, a test dataset is available for you.

You should make a directory to work in, e.g.:

::

   bash% mkdir -p ~/DATA/where_I_put_the_notes
   bash% cd ~/DATA/where_I_put_the_notes

Then, download (selecting from menu) the test data file
```LT51220441995364-SC20150217103827.tar.gz`` <http://www2.geog.ucl.ac.uk/~plewis/Geog2021_Coursework/LT51220441995364-SC20150217103827.tar.gz>`__,
or do one of the following:

``bash% wget http://www2.geog.ucl.ac.uk/~plewis/Geog2021_Coursework/LT51220441995364-SC20150217103827.tar.gz``

or, if you are on the UCL Geography system, you can simply copy the
file:

``bash% cp ~plewis/p/Geog2021_Coursework/LT51220441995364-SC20150217103827.tar.gz ~/DATA/where_I_put_the_notes``

Accessing the notes via a web page
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

These coursenotes are available as web pages from the `Geog 0027 course
overview page <http://www2.geog.ucl.ac.uk/~plewis/geog0027>`__ or more
directly from the `practical introduction
page <docs/CW-1-Pearl-River-Intro.ipynb>`__.

Accessing the notes via github
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The notes are also available on
`github <https://github.com/profLewis/Geog0027_Coursework>`__. You can
directly download the notes from
`github <https://github.com/profLewis/Geog0027_Coursework>`__, either
using some ```git`` <http://en.wikipedia.org/wiki/Git_(software)>`__
software, e.g:

::

   bash% mkdir -p ~/DATA/where_I_put_the_notes
   bash% cd ~/DATA/where_I_put_the_notes
   bash% git clone https://github.com/profLewis/Geog2021_Coursework.git

or by downloading the `course notes as a zip
file <https://github.com/profLewis/Geog0027_Coursework/archive/master.zip>`__.

If you use ``git``, you can apply any updates to the notes:

::

   bash% mkdir -p ~/DATA/where_I_put_the_notes
   bash% cd ~/DATA/where_I_put_the_notes/Geog2021_Coursework
   bash% git reset --hard HEAD
   bash% git pull

You can also fork the notes and create your own version.

Using the notes for Geog 0027
-----------------------------

You can of course just read and digest the html notes, but you will find
that there are snippets of computer code (in Python) at times. Note that
you **do not** need to use the Python codes to do this coursework: you
can do everything you need in ENVI and Excel. That said, you will be
processing quite a number of images, and you may find the Python codes
useful for at least semi-automating the tasks.

Running ipython to use the notes for Geog 0027
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Assuming you are on a unix system (including OS X, linux etc.), then
first change directory to where the notes are:

::

   bash% mkdir -p ~/DATA/where_I_put_the_notes
   bash% cd ~/DATA/where_I_put_the_notes/Geog2021_Coursework

Then start an [``ipython``] session:

``bash% ipython``

Then, for example, following the code in the
```Download`` <docs/Download.ipynb>`__ section, type or paste the
following at the ipython prompt (``In [1]:``):

::

   import sys
   sys.path.insert(0,'python')
   from uncompress_ls import uncompress_ls
   from sort_landsat import sort_landsat

This will load some python codes from the local ``python`` directory
that you can use.

Again, following the example, we can specify a Landsat data file:

``dirname = 'LT51220441995364-*.tar.gz'``

which assumes there is one or more files that match the pattern
``LT51220441995364-*.tar.gz`` in the current directoy (‘folder’) (see
section above on downloading a test dataset).

Then, uncompress this file with:

``files = uncompress_ls(dirname)``

The variable ``files`` then contains a list of the files:

::

   print files
   [array(['/tmp/tmp0ImQHU/LT51220441995364CLT00_cfmask.tif',
          '/tmp/tmp0ImQHU/LT51220441995364CLT00_sr_adjacent_cloud_qa.tif',
          '/tmp/tmp0ImQHU/LT51220441995364CLT00_sr_atmos_opacity.tif',
          '/tmp/tmp0ImQHU/LT51220441995364CLT00_sr_band1.tif',
          '/tmp/tmp0ImQHU/LT51220441995364CLT00_sr_band2.tif',
          '/tmp/tmp0ImQHU/LT51220441995364CLT00_sr_band3.tif',
          '/tmp/tmp0ImQHU/LT51220441995364CLT00_sr_band4.tif',
          '/tmp/tmp0ImQHU/LT51220441995364CLT00_sr_band5.tif',
          '/tmp/tmp0ImQHU/LT51220441995364CLT00_sr_band7.tif',
          '/tmp/tmp0ImQHU/LT51220441995364CLT00_sr_cloud_qa.tif',
          '/tmp/tmp0ImQHU/LT51220441995364CLT00_sr_cloud_shadow_qa.tif',
          '/tmp/tmp0ImQHU/LT51220441995364CLT00_sr_ddv_qa.tif',
          '/tmp/tmp0ImQHU/LT51220441995364CLT00_sr_fill_qa.tif',
          '/tmp/tmp0ImQHU/LT51220441995364CLT00_sr_land_water_qa.tif',
          '/tmp/tmp0ImQHU/LT51220441995364CLT00_sr_snow_qa.tif'], 
         dtype='|S61')]

Now, you can subset the data:

::

   ofiles = sort_landsat(files)

which will produce the extracted files you need. You can now quite
``ipython`` (^D and confirm ``y``).

You should see that the python codes have generated two files
``LT51220441995364CLT00_mask.tif`` and
``LT51220441995364CLT00_refl.tif``:

::

   bash% ls -l *tif
   -rw-rw-r--. 1 plewis plewis 10768420 Feb 26 10:32 LT51220441995364CLT00_mask.tif
   -rw-rw-r--. 1 plewis plewis 42996634 Feb 26 10:31 LT51220441995364CLT00_refl.tif

Running ipython notebooks to use the notes for Geog 0027
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In many ways a better approach is to use the ipython notebooks:

::

   bash% mkdir -p ~/DATA/where_I_put_the_notes
   bash% cd ~/DATA/where_I_put_the_notes/Geog2021_Coursework

Then start a browser (e.g. firefox, safari etc) and start a
[``jupyter notebook``] session:

``bash% jupyter notebook``

This should open a page in your browser, e.g.
``http://localhost:8889/tree``

If you then e.g. click on the link
```Download.ipynb`` <http://localhost:8889/notebooks/Download.ipynb>`__,
this should run the notebook in a new tab in the browser.

You can now go through the notes, and run (and/or edit) the python codes
as they appear on the page.

The various images, text etc. are in ‘cells’ on the web page. To ‘run’ a
cell select the cursor in that cell and then either do ``Shift Return``
(i.e. Shift and Return keys at the same time), or click the ‘play’
button.


.. _Prof. P. Lewis: http://www2.geog.ucl.ac.uk/~plewis
.. _Prof. M. Disney: http://www2.geog.ucl.ac.uk/~mdisney
.. _Dr Qingling Wu: https://www.geog.ucl.ac.uk/people/research-staff/qingling-wu

