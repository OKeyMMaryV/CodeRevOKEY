﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	бит_Дополнительный_2Обороты.Регистратор КАК Документ,
		|	ИСТИНА КАК Выбрать
		|ИЗ
		|	РегистрБухгалтерии.бит_Дополнительный_2.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Запись,
		|			Счет В ИЕРАРХИИ (&Счет122и123),
		|			,
		|			Организация = &Организация
		|				И ВЫБОР
		|					КОГДА ВЫРАЗИТЬ(Субконто1 КАК Справочник.ОбъектыСтроительства) ССЫЛКА Справочник.ОбъектыСтроительства
		|						ТОГДА Субконто1 В ИЕРАРХИИ (&Субконто1)
		|					КОГДА ВЫРАЗИТЬ(Субконто2 КАК Справочник.ОбъектыСтроительства) ССЫЛКА Справочник.ОбъектыСтроительства
		|						ТОГДА Субконто2 В ИЕРАРХИИ (&Субконто1)
		|				КОНЕЦ,
		|			,
		|			) КАК бит_Дополнительный_2Обороты";
	
		СчетаБУ = Новый Массив;
		СчетаБУ.Добавить(ПланыСчетов.Хозрасчетный.ОсновныеСредства); // счет01
		СчетаБУ.Добавить(ПланыСчетов.Хозрасчетный.ДоходныеВложенияВ_МЦ); // счет03
		СчетаБУ.Добавить(ПланыСчетов.Хозрасчетный.СтроительствоОбъектовОсновныхСредств); // счет08.03
		СчетаБУ.Добавить(ПланыСчетов.Хозрасчетный.ПриобретениеЗемельныхУчастков); // счет08.01
		СчетаБУ.Добавить(ПланыСчетов.Хозрасчетный.ПриобретениеОбъектовПриродопользования); // счет08.02
		//СчетаБУ.Добавить(ПланыСчетов.Хозрасчетный.ПриобретениеОбъектовОсновныхСредств); // счет08.04
		СчетаБУ.Добавить(ПланыСчетов.Хозрасчетный.ПриобретениеКомпонентовОсновныхСредств); // счет08.04.01           //ОК Довбешка Т. 17.04.2017 исправление ошибки после обновления релиза
		СчетаБУ.Добавить(ПланыСчетов.Хозрасчетный.ОборудованиеКУстановке); // счет07

		
		МассивСчетов122И123  = Новый Массив;
		МассивСчетов122И123.Добавить(ПланыСчетов.бит_Дополнительный_2.НезавершенноеСтроительствоЗдания); //122
		МассивСчетов122И123.Добавить(ПланыСчетов.бит_Дополнительный_2.НезавершенноеСтроительствоОборудование); //123
		
		Запрос.УстановитьПараметр("КонецПериода", КонецДня(Параметры.ДатаДок));
		Запрос.УстановитьПараметр("КорСчет", ПланыСчетов.бит_Дополнительный_2.Служебный); //служебный
		Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(Дата('20140101'))); //по заявке 1 января 2014
		Запрос.УстановитьПараметр("Организация", Параметры.Организация);
		Запрос.УстановитьПараметр("Субконто1", Параметры.ОбъектСтроительства);//объект строительства
		Запрос.УстановитьПараметр("Счет122", ПланыСчетов.бит_Дополнительный_2.НезавершенноеСтроительствоЗдания);
		Запрос.УстановитьПараметр("Счет123", ПланыСчетов.бит_Дополнительный_2.НезавершенноеСтроительствоОборудование); 
		Запрос.УстановитьПараметр("Счет1", ПланыСчетов.бит_Дополнительный_2.ВнеоборотныеАктивы);
		Запрос.УстановитьПараметр("Счет122И123", МассивСчетов122И123);
		Запрос.УстановитьПараметр("СчетаБУ", СчетаБУ);
	
	ТаблицаДокументов.Загрузить(Запрос.Выполнить().Выгрузить());
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьДокументы(Команда)
	
	СписокВыбранныхДокументов = Новый  СписокЗначений;
	
	Для каждого строка из ТаблицаДокументов Цикл 
		Если строка.Выбрать = Истина Тогда
			СписокВыбранныхДокументов.Добавить(строка.Документ);
		КонецЕсли;
	КонецЦикла;
	ОповеститьОВыборе(СписокВыбранныхДокументов.ВыгрузитьЗначения());
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельПереченьОбъектовВключитьВсе(Команда)
	
	бит_РаботаСДиалогамиКлиент.ОбработатьФлагиТаблицы(ТаблицаДокументов, "Выбрать", 1);

КонецПроцедуры

&НаКлиенте
Процедура ПереченьОбъектовСнятьФлажки(Команда)
	бит_РаботаСДиалогамиКлиент.ОбработатьФлагиТаблицы(ТаблицаДокументов, "Выбрать", 0);

КонецПроцедуры
