import 'org.apache.hadoop.hbase.client.HTable'
import 'org.apache.hadoop.hbase.client.Put'
import 'javax.xml.stream.XMLStreamConstants'

def jbytes( *args )
  args.map { |arg| arg.to_s.to_java_bytes }
end

factory = javax.xml.stream.XMLInputFactory.newInstance
reader = factory.createXMLStreamReader(java.lang.System.in)

document = nil
buffer = nil
count = 0

table = HTable.new( @hbase.configuration, 'foods' )
table.setAutoFlush( false )

while reader.has_next
  type = reader.next
  
  if type == XMLStreamConstants::START_ELEMENT
  
    case reader.local_name
    when 'Food_Display_Row' then document = {}
    else buffer = []
    end
    
  elsif type == XMLStreamConstants::CHARACTERS
    
    buffer << reader.text unless buffer.nil?
    
  elsif type == XMLStreamConstants::END_ELEMENT
    
    case reader.local_name
    when 'Food_Display_Row'
      key = document['Food_Code'].to_java_bytes
      
      p = Put.new( key )
      document.keys.select { |k| k != 'Food_Code' }.each do |key| 
        p.add( *jbytes( "facts", key, document[key] ) )
      end
      table.put( p )
      
      count += 1
      table.flushCommits() if count % 10 == 0
      if count % 100 == 0
        puts "#{count} records inserted (#{document['Display_Name']})"
      end
    else
      document[reader.local_name] = buffer.join
    end
  end
end

table.flushCommits()
exit
