class Graph{
  List<Node> nodes;
  List<Edge> edges;

  Graph(this.nodes,this.edges);

  ///Checks if all Edges in the graph are marked
  bool isEveryEdgeMarked(){
    return edges.every((acEdge){
      return acEdge.marked;
    });
  }

  ///Checks if the Node [firstNode] is connected to the Node [secondNode]
  ///
  /// Doesn´t mind direction
  bool isConnected(Node firstNode,Node secondNode){
    return edges.any((acEdge){
      return (acEdge.firstNode==firstNode&&acEdge.secondNode==secondNode)||(acEdge.firstNode==secondNode&&acEdge.secondNode==firstNode);
    });
  }
///Checks if the Node with index [firstNodeIndex] is connected to the Node with index [secondNodeIndex]
  ///
  /// Doesn´t mind direction
  bool isConnectedByIndex(int firstNodeIndex, int secondNodeIndex){
    return isConnected(this.nodes[firstNodeIndex], this.nodes[secondNodeIndex]);
  }

  ///Returns the Edge with the given Nodes
  Edge getEdge(Node firstNode, Node secondNode){
    return getEdgeByIndex(this.nodes.indexOf(firstNode), this.nodes.indexOf(secondNode));
  }

  ///Returns the Edge with the given Nodes with [firstNodeIndex] and [secondNodeIndex]
  Edge getEdgeByIndex(int firstNodeIndex, int secondNodeIndex){
    Edge returnEdge;
    this.edges.forEach((acEdge){
      if((acEdge.firstNode==this.nodes[firstNodeIndex]&&acEdge.secondNode==this.nodes[secondNodeIndex])||(acEdge.secondNode==this.nodes[firstNodeIndex]&&acEdge.firstNode==this.nodes[secondNodeIndex])){
        returnEdge= acEdge;
      }
    });
    return returnEdge;
  }

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

  ///Returns [qunatity] subgraphes
  ///
  /// The nodes in the subgraphes should have a similar degree
  List<Graph> getSubgraphs( List<int> weight,[List<Graph> subgraphs]){

    int index=0;
    int completeWeight=0;
    weight.forEach((acWeight)=>completeWeight=completeWeight+acWeight);
    List<int> realIndex=List(completeWeight);
    weight.forEach((acWeight) {
      for(int i=0;i<acWeight;i++){
        realIndex[index]=weight.indexOf(acWeight);
        index++;
      }
    });
    index =0;

    if((subgraphs==null)) {
      subgraphs = List(weight.length);
      for (int i = 0; i < weight.length; i++) {
        List<Node> newNodes = [];
        this.nodes.forEach((acNode) {
          newNodes.add(new Node(acNode.name));
        });
        subgraphs[i] = Graph(newNodes, []);
      }
    }

    while(!isEveryEdgeMarked()){
      Node choosenFirstNode;
      Node choosenSecondNode;
      subgraphs[realIndex[index]].nodes.forEach((acfirstNode){
          if(this.nodes[subgraphs[realIndex[index]].nodes.indexOf(acfirstNode)].value<this.nodes.length-1){
            if(choosenFirstNode==null){
              choosenFirstNode=acfirstNode;
            }
            else{
              if(acfirstNode.degree<choosenFirstNode.degree){
                choosenFirstNode=acfirstNode;
              }
              else if(acfirstNode.degree==choosenFirstNode.degree){
                if(this.nodes[subgraphs[realIndex[index]].nodes.indexOf(acfirstNode)].value>this.nodes[subgraphs[realIndex[index]].nodes.indexOf(choosenFirstNode)].value){
                  choosenFirstNode=acfirstNode;
                }
              }
            }
          }
      });
      subgraphs[realIndex[index]].nodes.forEach((acSecondNode){
        if(acSecondNode!=choosenFirstNode){
          if(!getEdgeByIndex(subgraphs[realIndex[index]].nodes.indexOf(acSecondNode), subgraphs[realIndex[index]].nodes.indexOf(choosenFirstNode)).marked){
            if(this.nodes[subgraphs[realIndex[index]].nodes.indexOf(acSecondNode)].value<this.nodes.length-1){
              if(choosenSecondNode==null){
                choosenSecondNode=acSecondNode;
              }
              else{
                if(acSecondNode.degree<choosenSecondNode.degree){
                  choosenSecondNode=acSecondNode;
                }
                else if(acSecondNode.degree==choosenSecondNode.degree){
                  if(this.nodes[subgraphs[realIndex[index]].nodes.indexOf(acSecondNode)].value>this.nodes[subgraphs[realIndex[index]].nodes.indexOf(choosenSecondNode)].value){
                    choosenSecondNode=acSecondNode;
                  }
                }
              }
            }
          }
        }
      });
      subgraphs[realIndex[index]].edges.add(new Edge(choosenFirstNode, choosenSecondNode));
      this.markEdge(getEdgeByIndex(subgraphs[realIndex[index]].nodes.indexOf(choosenFirstNode), subgraphs[realIndex[index]].nodes.indexOf(choosenSecondNode)));
      index =(index+1)%completeWeight;
    }
    return subgraphs;
  }
}

class Node{
  String name;
  int value;
  int degree;

  Node(this.name, [this.value=0]){
    this.degree=0;
  }
}

class Edge{
  Node firstNode;
  Node secondNode;
  bool direction;
  bool marked;
  int value;

  Edge(this.firstNode, this.secondNode, [this.direction= false, this.marked=false, this.value=0]){
    this.firstNode.degree++;
    this.secondNode.degree++;
  }

  ///Checks if [toTest] is part of the Edge
  bool isNodeLinked(Node toTest){
    if(firstNode==toTest||secondNode==toTest){
      return true;
    }
    return false;
  }

  ///Returns the added Degree from the two connected Nodes
  int getDegreeOfNodes(){
    return firstNode.degree+secondNode.degree;
  }

  ///Updates the value of the Edge
  ///
  /// The Value is calculated by adding the two Values of the Nodes
  void updateValue(){
    this.value =firstNode.value+secondNode.value;
  }
}