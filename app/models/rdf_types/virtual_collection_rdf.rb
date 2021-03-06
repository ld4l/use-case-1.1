module RDFTypes
  class VirtualCollectionRDF < RDFTypes::ResourceExtension

    @id_prefix="vc"

    # TODO... Can we change type from Set to List to go from unordered list to ordered list?
    # TODO    Should properties for ordered lists be blocked until the list is turned into an ordered list?
    # TODO    Can you go from an ordered list back to an unordered list?
    # TODO    Can you apply order to only parts of the list, or does applying order imply all items are now ordered?
    # TODO    If all items are now ordered, what is the process for going through all subitems and adding order information?

    # ORDERED_LIST_TYPE   = RDFVocabularies::CO.List
    # UNORDERED_LIST_TYPE = RDFVocabularies::CO.Set
    #
    # # configure :type => ORDERED_LIST_TYPE, :base_uri => Rails.configuration.urigenerator.base_uri, repository => :default
    # configure :type => UNORDERED_LIST_TYPE, :base_uri => Rails.configuration.urigenerator.base_uri, repository => :default
    configure :type => RDFVocabularies::ORE.Aggregation, :base_uri => Rails.configuration.urigenerator.base_uri, :repository => :default

    # extended properties for LD4L implementation
    property :title,       :predicate => RDF::DC.title
    property :description, :predicate => RDF::DC.description
    property :owner,       :predicate => RDFVocabularies::DCTERMS.creator, :class_name => RDFTypes::PersonRDF

    # # properties from CO.List
    # property :size,        :predicate => RdfVocabularies::CO.size
    # property :item,        :predicate => RdfVocabularies::CO.item,      :class_name => RDFTypes::VirtualCollectionItemRDF         # multiple values
    # property :firstItem,   :predicate => RdfVocabularies::CO.firstitem, :class_name => RDFTypes::VirtualCollectionItemRDF
    # property :lastItem,    :predicate => RdfVocabularies::CO.lastitem,  :class_name => RDFTypes::VirtualCollectionItemRDF

    # properties from ORE.Aggregation
    property :aggregates,   :predicate => RDFVocabularies::ORE.aggregates   # multiple values


    # --------------------- #
    #    HELPER METHODS     #
    # --------------------- #

    # Create a virtual collection in one step passing in the required information.  TODO: Are any of the inputs optional?
    def self.create( options = {} )
      id             = options[:id]          || generate_id
      vc = RDFTypes::VirtualCollectionRDF.new(id)
      vc.title       = options[:title]       || []
      vc.description = options[:description] || []
      vc.owner       = options[:owner]       || []
      vc
    end

    # Add a single item URI to the items for the virtual collection.  ORE ontology style lists.
    # Optionally insert the item at the passed position.  Append when position is nil.
    # NOTE: Ordered lists is currently not supported.  TODO: Implement ordered lists.
    # TODO: WARNING: This does not look like it would scale.  Getting all, adding to array, and setting all.  Very costly when there are 10s of thousands.
    def add_item_with_content(content,insert_position=nil)
      # aggregates = get_values('aggregates')
      # aggregates << content
      # set_value('aggregates',aggregates)
      aggregates = self.aggregates.dup
      aggregates << content
      self.aggregates = aggregates
      RDFTypes::VirtualCollectionItemRDF.create(:content => content, :virtual_collection => self, :insert_position => insert_position)
    end

    # Adds each item in the item_array to the items for the virtual collection
    def add_items_with_content(content_array)
      vci_array = []
      content_array.each { |content| vci_array << add_item_with_content(content) }
      vci_array
    end

    # Returns an array the items in the virtual collections
    # TODO: How to begin at start and limit to number of returned items, effectively handling ranges of data.
    def get_items_content(start=nil,limit=nil)
      # TODO: Stubbed to return all items.
      get_values('aggregates')
    end

    # Returns an array of persisted RDFTypes::VirtualCollectionItemRDF instances for the items in the virtual collections
    def get_items(start=nil,limit=nil)
      RDFTypes::VirtualCollectionItemRDF.get_range(self, start, limit)
    end

    # Get the persisted RDFTypes::VirtualCollectionItemRDF instance that holds the content
    # NOTE: Not implemented.
    def find_item_with_content(content)
      # TODO Stubbed - Requires definition and implementation
    end

    # Return the content at the specified position in an ordered collection
    def get_item_content_at(position)
      # TODO Stubbed - Required definition and implementation
    end

    # Return the RDFTypes::VirtualCollectionItemRDF instance for the item at the specified position in an ordered collection
    def get_item_at(position)
      # TODO Stubbed - Required definition and implementation
    end

    # Determine if the content is already in the virtual collection
    def has_item_content?(content)
      # TODO Stubbed - Requires definition and implementation
    end

    # Determine if an item exists at the specified position in the ordered virtual collection
    def has_item_at?(position)
      # TODO Stubbed - Requires definition and implementation
    end

    # Destroy the item with the content and remove content from the virtual collection
    def destroy_item_with_content(content)
      # TODO Stubbed - Requires definition and implementation
    end

    # Destroy the item at specified position and remove content from the virtual collection
    def destroy_item_at(position)
      # TODO Stubbed - Requires definition and implementation
    end

    # Determine if the virtual collection holds an ordered list of items
    def is_ordered?
      # TODO Stubbed - Requires definition and implementation
    end
  end
end

