function [class_N,class_S,class_V,class_F,class_U,segments_class] = Mostrar_arritmias(class,signals)

signals{1}=signals{1}';


class_N = signals{1}(find(class == 1),:);
class_S = signals{1}(find(class == 2),:);
class_V = signals{1}(find(class == 3),:);
class_F = signals{1}(find(class == 4),:);
class_U = signals{1}(find(class == 5),:);

class_N=class_N';
class_S=class_S';
class_V=class_V';
class_F=class_F';
class_U=class_U';

segments_class{1}=class_N;
segments_class{2}=class_S;
segments_class{3}=class_V;
segments_class{4}=class_F;
segments_class{5}=class_U;
end

