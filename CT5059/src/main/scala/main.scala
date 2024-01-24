//Importing classes
import scala.collection.immutable.ListMap
import scala.util.matching.Regex
object main {
  def main(args: Array[String]) = {
    //Lists of threats and vulnerability words
    val threatWords = List("threat", "vulnerabilities", "attack", "loopholes", "whitelist", "blacklist", "hash", "encryption")
    val connectWords = List("and", "or", "to", "also", "the", "like", "as", "too", "but", "unlike", "for", "an", "in", "a", "from")

    //Count words into lower case
    val words = scala.io.Source.fromFile("email1.txt").getLines
      .flatMap(_.split("\\W+"))
      .foldLeft(collection.mutable.Map.empty[String, Int]) {(count, word) =>
                count + (word.toLowerCase() -> (count.getOrElse(word.toLowerCase(), 0) + 1))
      }

    //Remove connecting words from words list
    connectWords.foreach(elem => words.remove(elem))
    words.remove("");

    //Sorting the list and displaying the 10 most used words
    val sortedWords = ListMap(words.toSeq.sortWith(_._2 > _._2):_*)
    val usedWords = sortedWords.take(10)
    usedWords.foreach(elem => println(elem._1 + " " + elem._2.toString))

    //Count how many threat words are present
    var flag:Int = 0
    for (elem <- threatWords) {
      if(words.contains(elem))
      {
        val count: Int = words.getOrElse(elem,0);
        flag = flag + count
      }
    }

    //Flagging an email
    if(flag >= 5){
      println("This email is suspicious!")
    }
    else{
      println("This email is benign.")
      }
  }
}