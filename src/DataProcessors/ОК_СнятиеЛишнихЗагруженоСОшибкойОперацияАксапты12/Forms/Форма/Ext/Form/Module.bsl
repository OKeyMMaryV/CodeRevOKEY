

&НаСервере
Функция КнопкаВыполнитьНажатиеНаСервере()
	
	Если ПроверитьЗаполнение() Тогда 
		СнятьФлаги();
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура КнопкаВыполнитьНажатие(Команда)
	
	КнопкаВыполнитьНажатиеНаСервере();
	
КонецПроцедуры

&НаСервере
Функция СнятьФлаги()
	
	_объект = РеквизитФормыВЗначение("Объект");
	_объект.СнятьФлаги();
	
КонецФункции