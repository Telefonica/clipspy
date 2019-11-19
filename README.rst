CLIPS Python bindings
=====================

This is a fork on `CLIPS Python bindings <https://github.com/noxdafox/clipspy>`_ providing a simple rules based reasoning
flow based on CLIPS and management for scaling up the use of multiple rules engines.

---------------------

**Remark**

    Read the `Auracog Rules User Guide <doc/user_guide/auracog_rules_user_guide.rst>`_ for a description on this functionality.
---------------------


Python CFFI_ bindings for the ‘C’ Language Integrated Production System CLIPS_ 6.30.

:Source: https://github.com/noxdafox/clipspy
:Documentation: https://clipspy.readthedocs.io
:Download: https://pypi.python.org/pypi/clipspy

|travis badge| |docs badge|

.. |travis badge| image:: https://travis-ci.org/noxdafox/clipspy.svg?branch=master
   :target: https://travis-ci.org/noxdafox/clipspy
   :alt: Build Status
.. |docs badge| image:: https://readthedocs.org/projects/clipspy/badge/?version=latest
   :target: http://clipspy.readthedocs.io/en/latest/?badge=latest
   :alt: Documentation Status


Initially developed at NASA’s Johnson Space Center, CLIPS is a rule-based programming language useful for creating expert and production systems where a heuristic solution is easier to implement and maintain than an imperative one. CLIPS is designed to facilitate the development of software to model human knowledge or expertise.

CLIPSPy brings CLIPS capabilities within the Python ecosystem.


New Features (Work on Progress)
-------------------------------

Provide a flow based interface for easy use of rules engines:

- RulesEngine class encapsulating reasoning flows in three steps:

  1. set_facts() / set_slots()

     Assert facts to the rules engine.

  2. reason()

     Execute rules chaining on the current facts (rules based reasoning).

  3. collect_fact_values() / collect_resulting_slots

     Get the resulting facts containing reasoning results.

- Rules Engine Pool:

  - Two modes:

    - Stateless: The internal state (working memory, agenda, etc...) of the rules engines is not kept between two
      consecutive invocations to the pool. A reset operation is automatically done after engine release.
      **All engines in the pool are identical**.

    - Stateful: The internal state is saved for every engine in the pool. The programmer is responsible for the rules
      state management.
      **All engines in the pool are different** since they may have a completely different internal state. Threfore,
      engine instances must be named until finally released. A **persistence** mechanism for engine state is needed.



Installation
------------

Linux
+++++

On Linux, CLIPSPy is packaged for `x86_64` architectures as a wheel according to PEP-513_ guidelines.
Most of the distributions should be supported.

.. code:: bash

    $ [sudo] pip install clipspy

Windows
+++++++

CLIPSPy comes as a wheel for most of the Python versions and architectures.

.. code:: batch

    > pip install clipspy

The *libclips* and *libclips-dev* packages are available for download in the `linux_libs <linux_libs>`_ folder.

Building from sources
+++++++++++++++++++++

The provided Makefile takes care of retrieving the CLIPS source code and compiling the Python bindings together with it.

.. code:: bash

    $ make
    $ sudo make install

Please check the documentation_ for more information regarding building CLIPSPy from sources.

Example
-------

.. code:: python

    from clips import Environment, Symbol

    environment = Environment()

    # load constructs into the environment
    environment.load('constructs.clp')

    # assert a fact as string
    environment.assert_string('(a-fact)')

    # retrieve a fact template
    template = environment.find_template('a-fact')

    # create a new fact from the template
    fact = template.new_fact()

    # implied (ordered) facts are accessed as lists
    fact.append(42)
    fact.extend(("foo", "bar"))

    # assert the fact within the environment
    fact.assertit()

    # retrieve another fact template
    template = environment.find_template('another-fact')
    fact = template.new_fact()

    # template (unordered) facts are accessed as dictionaries
    fact["slot-name"] = Symbol("foo")

    fact.assertit()

    # execute the activations in the agenda
    environment.run()

.. _CLIPS: http://www.clipsrules.net/
.. _CFFI: https://cffi.readthedocs.io/en/latest/index.html
.. _PEP-513: https://www.python.org/dev/peps/pep-0513/
.. _documentation: https://clipspy.readthedocs.io
