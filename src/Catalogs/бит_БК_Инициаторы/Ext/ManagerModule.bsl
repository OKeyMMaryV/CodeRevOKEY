
//1c-izhtc spawn (

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если НЕ РольДоступна("Guest") Тогда 
		Возврат;
	КонецЕсли;
	
	Если ВидФормы = "ФормаОбъекта" ИЛИ ВыбраннаяФорма = "ФормаЭлемента" Тогда 
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "УпрФормаЭлемента";
	КонецЕсли;
	
КонецПроцедуры

//1c-izhtc spawn )
