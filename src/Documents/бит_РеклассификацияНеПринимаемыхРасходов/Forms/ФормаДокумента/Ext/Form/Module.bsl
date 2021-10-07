﻿
&НаКлиенте
Процедура ДействияФормыЗаполнитьОборотыПоДебету(Команда)
	    Объект.ТаблицаРазноски.Очистить();
		Объект.ДтКт = "Дт";
        ВыполнениеЗапроса_Вызов_Функции();	
КонецПроцедуры

&НаСервере
Функция СчетНачалоВыбораИзСписка_Сервер()
	СписокВспомогательныйСчетов = Новый СписокЗначений;
	СписокВспомогательныйСчетов.Добавить(ПланыСчетов.бит_Дополнительный_2.НайтиПоКоду("ВСП005"));
	СписокВспомогательныйСчетов.Добавить(ПланыСчетов.бит_Дополнительный_2.НайтиПоКоду("ВСП006"));
	
	Элементы.Счет.СписокВыбора.Очистить();
	Для Каждого тек_Значение_уник Из  СписокВспомогательныйСчетов Цикл
		Элементы.Счет.СписокВыбора.Добавить(тек_Значение_уник.Значение, тек_Значение_уник.Представление);
	КонецЦикла;
КонецФункции


&НаКлиенте
Процедура СчетНачалоВыбораИзСписка(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СчетНачалоВыбораИзСписка_Сервер();
КонецПроцедуры

&НаКлиенте
Процедура ДействияФормыЗаполнитьОборотыПоКредету(Команда)
	    Объект.ТаблицаРазноски.Очистить();
		Объект.ДтКт = "Кт";
        ВыполнениеЗапроса_Вызов_Функции();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Стандартные действия при создании на сервере
 	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	
	Объект.Индикатор = 0;
	Если Не Объект.Ссылка.Пустая() И Объект.РегистрБухгалтерии = ПредопределенноеЗначение("Справочник.бит_ОбъектыСистемы.ПустаяСсылка") Тогда
		Объект.РегистрБухгалтерии = Справочники.бит_ОбъектыСистемы.НайтиПоКоду("000001024");
		Записать();
	КонецЕсли;
	СчетНачалоВыбораИзСписка_Сервер();
КонецПроцедуры

&НаСервере
Процедура СчетНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = ЛОЖЬ;
КонецПроцедуры

&НаСервере
Функция ВыполнениеЗапроса_Вызов_Функции()
	_объект=РеквизитФормыВЗначение("Объект");
	результат = _объект.ВыполнениеЗапроса();
	ЗначениеВРеквизитФормы(_объект, "Объект");
КонецФункции

//ижтиси, шадрин, 14.08.2015(
&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	КоличествоВВыборке = ПередЗаписьюНаСервере();
	Если КоличествоВВыборке > 0 Тогда
		ОтветНаВопрос = Вопрос("Существуют документы с пересекающимся периодом. Продолжить запись?", РежимДиалогаВопрос.ДаНет);
		
		Если ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПередЗаписьюНаСервере()
	_объект=РеквизитФормыВЗначение("Объект");
	результат = _объект.ПоискДокументовСПересекающимисяПериодами();
	Возврат Результат.Количество();
КонецФункции
//ижтиси, шадрин, 14.08.2015)
