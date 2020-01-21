class Graph{
  List<Node> nodes;
  List<Edge> edges;

  Graph(this.nodes,this.edges);

  ///Marks [edgeMark] in the edgesList
  ///
  /// When [edgeMark] is not part of the List, nothing happens
  void markEdge(Edge edgeMark){
    int index = edges.indexOf(edgeMark);
    if(index!=-1){
      markEdgeByIndex(index);
    }
  }

  ///marks the Edge with given [index]
  ///
  /// if the index is not part of the Edges, nothing happens
  void markEdgeByIndex(int index){
    Edge markEdge = edges[index];
    if(markEdge!=null){
      markEdge.marked=true;
      markEdge.firstNode.value++;
      markEdge.secondNode.value++;
      edges.forEach((acEdge){
        if(acEdge.isNodeLinked(markEdge.firstNode)||acEdge.isNodeLinked((markEdge.secondNode))){
          acEdge.updateValue();
        }
      });
    }
  }

  ///Returns the Edge with the lowest value, that is not marked
  Edge getMinNotMarkedEdge(){
    Edge minEdge;
    edges.forEach((acEdge){
      if(!acEdge.marked){
        if(minEdge==null||acEdge.value<minEdge.value){
          minEdge = acEdge;
        }
      }
    });
    return minEdge;
  }

  ///Resets the Graph to rhe initial State
  void clearMarksAndValues(){
    nodes.forEach((acNode){
      acNode.value=0;
    });
    edges.forEach((acEdge){
      acEdge.marked=false;
      acEdge.updateValue();
    });
  }

  ///adds Edges for a complete Graph from the given Nodes
  void completeGraph(){
    edges=[];
    for(int i=0; i<nodes.length-1;i++){
      for(int j=i+1;j<nodes.length;j++){
        Edge acEdge = Edge(nodes[i], nodes[j]);
        acEdge.updateValue();
        edges.add(acEdge);
      }
    }
  }
}

class Node{
  String name;
  int value;

  Node(this.name, [this.value=0]);
}

class Edge{
  Node firstNode;
  Node secondNode;
  bool direction;
  bool marked;
  int value;

  Edge(this.firstNode, this.secondNode, [this.direction= false, this.marked=false, this.value=0]);

  ///Checks if [toTest] is part of the Edge
  bool isNodeLinked(Node toTest){
    if(firstNode==toTest||secondNode==toTest){
      return true;
    }
    return false;
  }

  ///Updates the value of the Edge
  ///
  /// The Value is calculated by adding the two Values of the Nodes
  void updateValue(){
    this.value =firstNode.value+secondNode.value;
  }
}