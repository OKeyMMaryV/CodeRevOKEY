﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция СформироватьОтчет(ДанныеКонтрагентов, Параметры) Экспорт
	
	ТабличныйДокумент 	= Новый ТабличныйДокумент;
	
	ПараметрыОтчета = ПараметрыФормированияОтчета();
	
	// Заголовок
	Область = ПараметрыОтчета.Заголовок;
	Область.Параметры.Заголовок = Параметры.Заголовок;
	ТабличныйДокумент.Вывести(Область);
	
	ПредыдущееСостояние 	= Неопределено;
	ПредыдущийКонтрагент 	= Неопределено;
	
	ТабличныйДокумент.НачатьАвтогруппировкуСтрок();
	Для каждого СтрокаДанныхКонтрагентов Из ДанныеКонтрагентов Цикл
		
		ВывестиСостояние(СтрокаДанныхКонтрагентов, ПараметрыОтчета, ТабличныйДокумент, ПредыдущееСостояние);
		ВывестиКонтрагента(СтрокаДанныхКонтрагентов, ПараметрыОтчета, ТабличныйДокумент, ПредыдущийКонтрагент);
		ВывестиДокумент(СтрокаДанныхКонтрагентов, ПараметрыОтчета, ТабличныйДокумент);
	
	КонецЦикла; 
	ТабличныйДокумент.ЗакончитьАвтогруппировкуСтрок();

	ТабличныйДокумент.ТолькоПросмотр 	= Истина;
	ТабличныйДокумент.ОтображатьСетку 	= Ложь;
	
	Возврат ТабличныйДокумент;

КонецФункции

Процедура ВывестиСостояние(СтрокаДанныхКонтрагентов, ПараметрыОтчета, ТабличныйДокумент, ПредыдущееСостояние)
	
	Если ПредыдущееСостояние <> СтрокаДанныхКонтрагентов.Состояние Тогда
		
		Область = ПараметрыОтчета.Отступ;
		ТабличныйДокумент.Вывести(Область);

		ПредыдущееСостояние = СтрокаДанныхКонтрагентов.Состояние;
		
		Область = ПараметрыОтчета.Состояние;
		Область.Параметры.Состояние = НаименованиеСостояния(СтрокаДанныхКонтрагентов.Состояние);
		ТабличныйДокумент.Вывести(Область, 1, "Состояние", Истина);
		
	КонецЕсли;

КонецПроцедуры

Процедура ВывестиКонтрагента(СтрокаДанныхКонтрагентов, ПараметрыОтчета, ТабличныйДокумент, ПредыдущийКонтрагент)

	КлючКонтрагентаДляКонсолидации = СтрокаДанныхКонтрагентов.ИНН + "_"+ СтрокаДанныхКонтрагентов.КПП;
		
	КонтрагентИзменился = ЗначениеЗаполнено(СтрокаДанныхКонтрагентов.Контрагент)
		И ПредыдущийКонтрагент <> СтрокаДанныхКонтрагентов.Контрагент 
		ИЛИ НЕ ЗначениеЗаполнено(СтрокаДанныхКонтрагентов.Контрагент)
		И ПредыдущийКонтрагент <> КлючКонтрагентаДляКонсолидации;
	
	Если КонтрагентИзменился Тогда
		
		ЭтоКонсолидация = НЕ ЗначениеЗаполнено(СтрокаДанныхКонтрагентов.Контрагент);
		
		Если ЭтоКонсолидация Тогда
			ПредыдущийКонтрагент = СтрокаДанныхКонтрагентов.ИНН + "_"+ СтрокаДанныхКонтрагентов.КПП;;
			ВывестиКонтрагентаКонсолидации(СтрокаДанныхКонтрагентов, ПараметрыОтчета, ТабличныйДокумент);
		Иначе
			ПредыдущийКонтрагент = СтрокаДанныхКонтрагентов.Контрагент;
			ВывестиКонтрагентаНеКонсолидация(СтрокаДанныхКонтрагентов, ПараметрыОтчета, ТабличныйДокумент, ПредыдущийКонтрагент);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Процедура ВывестиКонтрагентаКонсолидации(СтрокаДанныхКонтрагентов, ПараметрыОтчета, ТабличныйДокумент)

	Если СтрДлина(СтрокаДанныхКонтрагентов.ИНН) = 12 Тогда
		Область = ПараметрыОтчета.СведенияПоИПКонсолидация;
	Иначе
		Область = ПараметрыОтчета.СведенияПоЮрЛицуКонсолидация;
		Область.Параметры.КПП = СтрокаДанныхКонтрагентов.КПП;
	КонецЕсли;
	
	Область.Параметры.ИНН = СтрокаДанныхКонтрагентов.ИНН;
	ТабличныйДокумент.Вывести(Область, 2, "Контрагент", Истина);

КонецПроцедуры

Процедура ВывестиКонтрагентаНеКонсолидация(СтрокаДанныхКонтрагентов, ПараметрыОтчета, ТабличныйДокумент, ПредыдущийКонтрагент)

	Если СтрДлина(СтрокаДанныхКонтрагентов.ИНН) = 12 Тогда
		Область = ПараметрыОтчета.СведенияПоИП;
	Иначе
		Область = ПараметрыОтчета.СведенияПоЮрЛицу;
		Область.Параметры.КПП = СтрокаДанныхКонтрагентов.КПП;
	КонецЕсли;
	
	Область.Параметры.Наименование 	= СтрокаДанныхКонтрагентов.КонтрагентНаименование;
	Область.Параметры.Контрагент 	= СтрокаДанныхКонтрагентов.Контрагент;
	Область.Параметры.ИНН = СтрокаДанныхКонтрагентов.ИНН;
	ТабличныйДокумент.Вывести(Область, 2, "Контрагент", Истина);

КонецПроцедуры

Процедура ВывестиДокумент(СтрокаДанныхКонтрагентов, ПараметрыОтчета, ТабличныйДокумент)

	 Если ЗначениеЗаполнено(СтрокаДанныхКонтрагентов.Документ) Тогда
		 
		Область = ПараметрыОтчета.СведенияПоДокументу;
		
		Область.Параметры.Документ 		= СтрокаДанныхКонтрагентов.Документ;
		Область.Параметры.Представление = СтрокаДанныхКонтрагентов.ПредставлениеДокумента;
		
	Иначе
		
		// У консолидации нет ссылки на контрагента и документ.
		Если ЗначениеЗаполнено(СтрокаДанныхКонтрагентов.Сумма) Тогда
			Область = ПараметрыОтчета.СведенияПоДокументуВКонсолидации;
			Область.Параметры.Сумма = Формат(СтрокаДанныхКонтрагентов.Сумма, "ЧДЦ=2; ЧРГ=' '");
		Иначе
			Область = ПараметрыОтчета.СведенияПоДокументуВКонсолидацииБезСуммы;
		КонецЕсли;
		
		Область.Параметры.Дата = Формат(СтрокаДанныхКонтрагентов.Дата, "ДЛФ=D");
		Область.Параметры.Номер = СтрокаДанныхКонтрагентов.Номер;
		
	КонецЕсли;

	ТабличныйДокумент.Вывести(Область, 3, "Документ", Ложь);

КонецПроцедуры

Функция НаименованиеСостояния(Состояние)
	
	Наименование = "";
	Если Состояние = Перечисления.СостоянияСуществованияКонтрагента.КонтрагентОтсутствуетВБазеФНС Тогда
		Наименование = НСтр("ru = 'По данным ЕГРН сведения о контрагентах отсутствуют'");
	ИначеЕсли Состояние = Перечисления.СостоянияСуществованияКонтрагента.КППНеСоответствуетДаннымБазыФНС Тогда
		Наименование = НСтр("ru = 'По данным ЕГРН у контрагентов другой КПП'");
	ИначеЕсли Состояние = Перечисления.СостоянияСуществованияКонтрагента.НеДействуетИлиИзмененКПП Тогда
		Наименование = НСтр("ru = 'По данным ЕГРН контрагенты недействующие'");
	КонецЕсли;
	
	Возврат Наименование;

КонецФункции

Функция ПараметрыФормированияОтчета()
	
	Макет = Отчеты.ОтчетПоНекорректнымКонтрагентам.ПолучитьМакет("Макет");

	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("Заголовок", 				Макет.ПолучитьОбласть("Заголовок"));
	ДополнительныеПараметры.Вставить("Состояние", 				Макет.ПолучитьОбласть("Состояние"));
	ДополнительныеПараметры.Вставить("СведенияПоИП", 			Макет.ПолучитьОбласть("СведенияПоИП"));
	ДополнительныеПараметры.Вставить("СведенияПоИПКонсолидация", Макет.ПолучитьОбласть("СведенияПоИПКонсолидация"));
	ДополнительныеПараметры.Вставить("СведенияПоЮрЛицу", 		Макет.ПолучитьОбласть("СведенияПоЮрЛицу"));
	ДополнительныеПараметры.Вставить("СведенияПоЮрЛицуКонсолидация", Макет.ПолучитьОбласть("СведенияПоЮрЛицуКонсолидация"));
	ДополнительныеПараметры.Вставить("СведенияПоДокументу", 	Макет.ПолучитьОбласть("СведенияПоДокументу"));
	ДополнительныеПараметры.Вставить("СведенияПоДокументуВКонсолидации", Макет.ПолучитьОбласть("СведенияПоДокументуВКонсолидации"));
	ДополнительныеПараметры.Вставить("СведенияПоДокументуВКонсолидацииБезСуммы", Макет.ПолучитьОбласть("СведенияПоДокументуВКонсолидацииБезСуммы"));
	ДополнительныеПараметры.Вставить("Отступ", 					Макет.ПолучитьОбласть("Отступ"));
	
	Возврат ДополнительныеПараметры;

КонецФункции 

#КонецОбласти

#КонецЕсли