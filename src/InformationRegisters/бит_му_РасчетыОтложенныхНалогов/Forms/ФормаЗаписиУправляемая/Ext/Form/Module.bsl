#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	бит_РаботаСДиалогамиСервер.ФормаЗаписиРегистраПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект);

	СтавкаНалогаНаПрибыль = Запись.Документ.СтавкаНалогаНаПрибыль;
		
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события "ПриИзменении" поля "СуммаПР".
// 
&НаКлиенте
Процедура СуммаПРПриИзменении(Элемент)
	
	бит_му_ОбщегоНазначения.РасчитатьСуммыОтложенныхНалоговыхАктивовОбязательств(Запись, СтавкаНалогаНаПрибыль);
  		
КонецПроцедуры // СуммаПРПриИзменении()

#КонецОбласти

