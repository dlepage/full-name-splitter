# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

    #
    # Examples
    #

    EXAMPLES = {
      "John Smith"                    => [nil, "John",           "Smith"               ],
      "Ben Smith"                     => [nil, "Ben",            "Smith"               ],
      "Kevin J. O'Connor"             => [nil, "Kevin J.",       "O'Connor"            ],
      "Gabriel Van Helsing"           => [nil, "Gabriel",        "Van Helsing"         ],
      "Pierre de Montesquiou"         => [nil, "Pierre",         "de Montesquiou"      ],
      "Charles d'Artagnan"            => [nil, "Charles",        "d'Artagnan"          ],
      "Jaazaniah ben Shaphan"         => [nil, "Jaazaniah",      "ben Shaphan"         ],
      "Noda' bi-Yehudah"              => [nil, "Noda'",          "bi-Yehudah"          ],
      "Maria del Carmen Menendez"     => [nil, "Maria",          "del Carmen Menendez" ],
      "Alessandro Del Piero"          => [nil, "Alessandro",     "Del Piero"           ],

      "George W Bush"                 => [nil, "George W",       "Bush"                ],
      "George H. W. Bush"             => [nil, "George H. W.",   "Bush"                ],
      "James K. Polk"                 => [nil, "James K.",       "Polk"                ],
      "William Henry Harrison"        => [nil, "William Henry",  "Harrison"            ],
      "John Quincy Adams"             => [nil, "John Quincy",    "Adams"               ],

      "John Quincy"                   => [nil, "John",           "Quincy"              ],
      "George H. W."                  => [nil, "George H. W.",   nil                   ],
      "Van Helsing"                   => [nil, nil,              "Van Helsing"         ],
      "d'Artagnan"                    => [nil, nil,              "d'Artagnan"          ],
      "O'Connor"                      => [nil, nil,              "O'Connor"            ],

      "George"                        => [nil, "George",         nil                   ],
      "Kevin J. "                     => [nil, "Kevin J.",       nil                   ],

      "Thomas G. Della Fave"          => [nil, "Thomas G.",      "Della Fave"          ],
      "Anne du Bourg"                 => [nil, "Anne",           "du Bourg"            ],

      # German
      "Johann Wolfgang von Goethe"    => [nil, "Johann Wolfgang", "von Goethe"         ],

      # Spanish-speaking countries
      "Juan Martn de la Cruz Gez"     => [nil, "Juan Martn",     "de la Cruz Gez"      ],
      "Javier Reyes de la Barrera"    => [nil, "Javier",         "Reyes de la Barrera" ],
      "Rosa María Pérez Martínez Vda. de la Cruz" =>
                                         [nil, "Rosa María",    "Pérez Martínez Vda. de la Cruz"],

      # Italian
      "Federica Pellegrini"           => [nil, "Federica",       "Pellegrini"          ],
      "Leonardo da Vinci"             => [nil, "Leonardo",       "da Vinci"            ],
      # sounds like a fancy medival action movie star pseudonim
      "Alberto Del Sole"              => [nil, "Alberto",        "Del Sole"            ],
      # horror movie star pseudonim?
      "Adriano Dello Spavento"        => [nil, "Adriano",        "Dello Spavento"      ],
      "Luca Delle Fave"               => [nil, "Luca",           "Delle Fave"          ],
      "Francesca Della Valle"         => [nil, "Francesca",      "Della Valle"         ],
      "Guido Delle Colonne"           => [nil, "Guido",          "Delle Colonne"       ],
      "Tomasso D'Arco"                => [nil, "Tomasso",        "D'Arco"              ],

      # Dutch
      "Johan de heer Van Kampen"      => [nil, "Johan",          "de heer Van Kampen"  ],
      "Han Van De Casteele"           => [nil, "Han",            "Van De Casteele"     ],
      "Han Vande Casteele"            => [nil, "Han",            "Vande Casteele"      ],

      # Arabic
      "Suraih ibn Hani"               => [nil, "Suraih",         "ibn Hani"            ],
      "Sumayya bint Khubbat"          => [nil, "Sumayya",        "bint Khubbat"        ],
      "Muhammad al-Hallaj"            => [nil, "Muhammad",       "al-Hallaj"           ],
      "Layla bint Zuhayr ibn Yazid al-Nahdiyah" => [nil, "Layla","bint Zuhayr ibn Yazid al-Nahdiyah"],

      # Exceptions?
      # the architect Ludwig Mies van der Rohe, from the West German city of Aachen, was originally Ludwig Mies;
      "Ludwig Mies van der Rohe"      => [nil, "Ludwig",         "Mies van der Rohe"   ],

      # If comma is provided then split by comma

      "John, Quincy Adams"             => [nil, "John",    "Quincy Adams"              ],
      "Ludwig Mies, van der Rohe"      => [nil, "Ludwig Mies", "van der Rohe"          ],

      # Test ignoring unnecessary whitespaces
      "\t Ludwig  Mies\t van der Rohe "   => [nil, "Ludwig", "Mies van der Rohe"       ],
      "\t Ludwig  Mies,\t van  der Rohe " => [nil, "Ludwig Mies", "van der Rohe"       ],
      "\t Ludwig      "                   => [nil, "Ludwig", nil                       ],
      "  van  helsing "                   => [nil, nil, "van helsing"                  ],
      " , van  helsing "                  => [nil, nil, "van helsing"                  ],
      "\t Ludwig  Mies,\t van  der Rohe " => [nil, "Ludwig Mies", "van der Rohe"       ],

      # Honorifics
      "Mr John Smith"                     => ["Mr",   "John",           "Smith"        ],
      "Miss Anne du Bourg"                => ["Miss", "Anne",           "du Bourg"     ],
      "Ms Agatha Christie"                => ["Ms",   "Agatha",         "Christie"     ],
      "Sir Arthur Conan Doyle"            => ["Sir",  "Arthur Conan",   "Doyle"        ],
      "Mrs. J.K. Rowling"                 => ["Mrs",  "J.K.",           "Rowling"      ],
      "Dr. Seuss"                         => ["Dr",   nil,              "Seuss"        ],
      "Mr. Kevin J. O'Connor"             => ["Mr",   "Kevin J.",       "O'Connor"     ],
      "Hon. George W Bush"                => ["Hon",  "George W",       "Bush"         ],
      "Dr. John, Quincy Adams"            => ["Dr",   "John",    "Quincy Adams"        ],

    }

class Incognito
  include FullNameSplitter
  attr_accessor :first_name, :last_name, :honorific
end

describe Incognito do
  describe "#full_name=" do

    #
    # Environment
    #

    subject { Incognito.new }

    EXAMPLES.each do |full_name, split_name|
      it "should split #{full_name} to '#{split_name[0]}' and '#{split_name[1]}' and '#{split_name[2]}'" do
        subject.full_name = full_name
        [subject.honorific, subject.first_name, subject.last_name].should == split_name
      end

      it "should split #{full_name} to '#{split_name[0]}' and '#{split_name[1]}' and '#{split_name[2]}' when called as module function" do
        FullNameSplitter.split(full_name, true).should == split_name
      end

    end
  end
end

class CustomIncognito
  include FullNameSplitter
  full_name_splitter_options.merge!(
      :honorific  => :title
  )
  attr_accessor :first_name, :last_name, :title
end

describe CustomIncognito do
  describe "#full_name=" do

    #
    # Environment
    #

    subject { CustomIncognito.new }

    EXAMPLES.each do |full_name, split_name|
      it "should split #{full_name} to '#{split_name[0]}' and '#{split_name[1]}' and '#{split_name[2]}'" do
        subject.full_name = full_name
        [subject.title, subject.first_name, subject.last_name].should == split_name
      end
    end
  end
end

class CompatIncognito
  include FullNameSplitter
  attr_accessor :first_name, :last_name
end

describe CompatIncognito do
  describe "#full_name=" do

    #
    # Environment
    #

    subject { CompatIncognito.new }

    EXAMPLES.each do |full_name, split_name|
      first = split_name[0] || ''
      first += " " if split_name[0] and split_name[1]
      first += split_name[1] if split_name[1]
      first = first.gsub /[^\w]/, '' #punctuation doesn't really matter
      it "should split #{full_name} to '#{first}' and '#{split_name[2]}'" do
        subject.full_name = full_name
        first_name = (subject.first_name || '').gsub /[^\w]/, '' #punctuation doesn't really matter
        [first_name, subject.last_name].should == [first, split_name[2]]
      end
    end
  end
end
