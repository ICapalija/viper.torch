Downloads VIPeR dataset directly from https://vision.soe.ucsc.edu/node/178 and converts it to Torch tables.
Based on https://github.com/soumith/cifar.torch.git

VIPeR format
---------------
Writes 1 file: VIPeR.t7<br />
Two images of one pedestrian are placed one next to the other.

Example code:
```lua
th> viper = torch.load('VIPeR.t7')
th> print(viper)
{
        data : ByteTensor - size: 1264x3x96x96
        label : ByteTensor - size: 1264
}
```
