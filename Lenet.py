import torch.nn as nn # nn = "neural network" : des couches prêtes à l'emploi (Conv2d, Linear, ReLU, etc.)


from collections import OrderedDict
# OrderedDict = un dictionnaire qui garde l'ordre.


# -----------------------
# Bloc C1 : convolution + ReLU (fonction d'activation)
# -----------------------
class C1(nn.Module):

    def __init__(self):
        super(C1, self).__init__() # héritage des attributs de nn.Module

        self.c1 = nn.Sequential(OrderedDict([
            # nn.Sequential = on met des couches les unes après les autres.
            # Ce qui sort de la couche 1 va dans la couche 2, etc.

            #('c1', nn.Conv2d(1, 6, kernel_size=(5, 5))),
            ('c1', nn.Conv2d(1, 3, kernel_size=(5, 5))),
            
            # Conv2d = "un filtre de convolution qui glissera sur l'image"
            # 1 = nombre de canaux en entrée (image en noir et blanc = 1 canal)
            # 6 = nombre de filtres => donc 6 images de sortie (6 "cartes de caractéristiques")
            # kernel_size (5,5) = taille du filtre (5x5 pixels)

            ('relu1', nn.ReLU())
            # ReLU = on remplace tous les nombres négatifs par 0.
            # Exemple : [-2, 3, -1, 5] devient [0, 3, 0, 5]
        ]))

    def forward(self, img):
        # forward = ce que fait la machine quand on lui donne une image.
        output = self.c1(img)
        # On applique "conv puis relu" à l'image.
        return output


# -----------------------
# Bloc S1 : MaxPool (réduction)
# -----------------------
class S1(nn.Module):
    def __init__(self):
        super(S1, self).__init__()

        self.s1 = nn.MaxPool2d(kernel_size=(2, 2))
        # MaxPool2d = on coupe l'image en petits carrés 2x2
        # et on garde seulement le plus grand nombre dans chaque carré.
        # stride=2 veut dire qu'on saute de 2 cases à chaque fois (on ne chevauche pas).

    def forward(self, img):
        output = self.s1(img)
        return output


# -----------------------
# Bloc C2 : convolution + ReLU
# -----------------------
class C2(nn.Module):
    def __init__(self):
        super(C2, self).__init__()

        self.c2 = nn.Sequential(OrderedDict([
           # ('c2', nn.Conv2d(6, 16, kernel_size=(5, 5))), # nombre de canaux=6 (sortie de S1), nombre de filtres=16 (donc 16 sorties), taille du filtre=5x5
            ('c2', nn.Conv2d(3, 6, kernel_size=(5, 5))), # nombre de canaux=4 (sortie de S1), nombre de filtres=16 (donc 16 sorties), taille du filtre=5x5
            ('relu2', nn.ReLU()) #fonction d'activation ReLU
        ]))

    def forward(self, img):
        output = self.c2(img)
        return output


# -----------------------
# Bloc S2 : MaxPool (réduction)
# -----------------------
class S2(nn.Module):
    def __init__(self):
        super(S2, self).__init__()

        self.s2 = nn.MaxPool2d(kernel_size=(2, 2))

    def forward(self, img):
        output = self.s2(img)
        return output


# -----------------------
# Bloc F4 : couche fully-connected (comme une table de multiplication) + LogSoftmax
# -----------------------
class F4(nn.Module):
    def __init__(self):
        super(F4, self).__init__()

        self.f4 = nn.Sequential(OrderedDict([
            ('flatten', nn.Flatten()), # on aplatit l'entrée (pour passer de C3 à F4) 1*16x5x5 -> 1*400    1*8x5x5 -> 1*200
            #('f4', nn.Linear(400, 10)), # couche de 10 neurones
            ('f4', nn.Linear(150, 10)), # couche de 10 neurones
            
            # Linear : y = xW + b (une grande multiplication)
            #('sig5', nn.LogSoftmax(dim=-1))
        ]))

    def forward(self, img):
        output = self.f4(img)
        return output



# -----------------------
# LeNet-5 complet : on assemble les blocs
# -----------------------
class LeNet5(nn.Module):
    """
    Input - 1x32x32
    Output - 10
    """
    def __init__(self):
        super(LeNet5, self).__init__()

        # On met chaque bloc dans l'ordre
        self.c1 = C1()
        self.s1 = S1()
        self.c2 = C2()
        self.s2 = S2()
        self.f4 = F4()


    def forward(self, img):
        # img a une forme : (batch_size, 1, 32, 32)
        # Exemple : batch_size = 32 images à la fois

        output = self.c1(img)      # conv + relu
        output = self.s1(output)   # maxpool

        output = self.c2(output)   # conv + relu
        output = self.s2(output)   # maxpool

        output = self.f4(output)   # 16 -> 10 (log-probas)
        return output
