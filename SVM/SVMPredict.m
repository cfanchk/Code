% predicted_label为分类结果，accuracy为准确率
function [predicted_label,accuracy]=SVMPredict(test_matrix,test_label,model)
w=model.w;
b=model.b;
predicted_label=sign(w*test_matrix'-b)';
accuracy=length(nonzeros((predicted_label==test_label)))/length(test_label);
end