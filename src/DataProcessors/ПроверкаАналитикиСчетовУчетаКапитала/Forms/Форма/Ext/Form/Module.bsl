﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Обработки.ПроверкаАналитикиСчетовУчетаКапитала.ПроверитьАналитикуСчетовУчетаКапитала(Истина) Тогда
		ФормаНеДоступна = Истина;
		Возврат;
	КонецЕсли;
	
	НастройкаНеПроверятьПриНачалеРаботы = ХранилищеОбщихНастроек.Загрузить("ПроверкаАналитикиСчетовУчетаКапитала", "НеПроверятьПриНачалеРаботы");
	НеПроверятьПриНачалеРаботы = НастройкаНеПроверятьПриНачалеРаботы = Истина;
	
	СписокСчетов.Добавить(ПланыСчетов.Хозрасчетный.УставныйКапитал_ОбыкновенныеАкции);
	СписокСчетов.Добавить(ПланыСчетов.Хозрасчетный.УставныйКапитал_ПривилегированныеАкции);
	СписокСчетов.Добавить(ПланыСчетов.Хозрасчетный.СобственныеАкции_ПривилегированныеАкции);
	СписокСчетов.Добавить(ПланыСчетов.Хозрасчетный.СобственныеАкции_ОбыкновенныеАкции);

	ТаблицаДанных = ПолучитьДанныеДокументов();
	Если ТаблицаДанных.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
	ЗначениеВДанныеФормы(ТаблицаДанных, ТаблицаДокументов);
	
	Если НЕ ПравоДоступа("Редактирование", Метаданные.Документы.ОперацияБух) Тогда
		Элементы.ГруппаКоманды.Видимость         = Ложь;
		Элементы.Обновить.Видимость              = Ложь;
		Элементы.ДекорацияРасположение.Видимость = Ложь;
		Элементы.ДекорацияИсправление.Видимость  = Ложь;
		Элементы.НаборЗаписейХозрасчетный.ТолькоПросмотр = Истина;
	Иначе
		Элементы.ДекорацияНетПрав.Видимость      = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ПриЗакрытииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ФормаНеДоступна Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'Не найдено ошибочных записей!'"));
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицФормы

&НаКлиенте
Процедура ТаблицаДокументовПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ТаблицаДокументов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТекущийДокумент) Тогда
		ТекущийДокумент = ТекущиеДанные.Документ;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Если ТекущийДокумент <> ТекущиеДанные.Документ Тогда
			ТекущийДокумент = ТекущиеДанные.Документ;
			ОписаниеОповещения = Новый ОписаниеОповещения("ПередПереходомОкончание", ЭтотОбъект, ТекущийДокумент);
			ТекстВопроса = НСтр("ru='Записать изменения?'");
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
		КонецЕсли;
		
	Иначе
		ТекущиеДанные = Элементы.ТаблицаДокументов.ТекущиеДанные;
		ТекущийДокумент = ТекущиеДанные.Документ;
		ТаблицаДокументовПриАктивизацииСтрокиНаСервере(ТекущиеДанные.Документ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТаблицаДокументов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(,ТекущиеДанные.Документ);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейХозрасчетныйПриИзменении(Элемент)
	
	Если НЕ Модифицированность Тогда
		УправлениеФормой(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоПриИзменении(Элемент)
	
	Модифицированность = Истина;
	ТекущиеДанные = Элементы.НаборЗаписейХозрасчетный.ТекущиеДанные;
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	
	ТекущиеДанные = Элементы.ТаблицаДокументов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ЗаписатьИзменения();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отменить(Команда)
	
	Модифицированность = Ложь;
	ТекущиеДанные = Элементы.ТаблицаДокументов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ТаблицаДокументовПриАктивизацииСтрокиНаСервере(ТекущиеДанные.Документ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	Если Модифицированность Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередОбновлениемОкончание", ЭтотОбъект, ТекущийДокумент);
		ТекстВопроса = НСтр("ru='Записать изменения?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
		
	Иначе
		ОбновитьНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьДанныеДокументов()
	
	ТаблицаДокументов.Очистить();
	НаборЗаписейХозрасчетный.Очистить();
	
	МассивОрганизаций = ОбщегоНазначенияБПВызовСервераПовтИсп.ВсеОрганизацииДанныеКоторыхДоступныПоRLS(Ложь);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СписокСчетов",СписокСчетов);
	Запрос.УстановитьПараметр("МассивОрганизаций",МассивОрганизаций);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Хозрасчетный.Регистратор КАК Документ,
	|	Хозрасчетный.Организация КАК Организация,
	|	"""" КАК Отступ
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный КАК Хозрасчетный
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Субконто КАК ХозрасчетныйСубконто
	|		ПО Хозрасчетный.Период = ХозрасчетныйСубконто.Период
	|			И Хозрасчетный.Регистратор = ХозрасчетныйСубконто.Регистратор
	|			И Хозрасчетный.НомерСтроки = ХозрасчетныйСубконто.НомерСтроки
	|			И (ХозрасчетныйСубконто.Вид = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ЦенныеБумаги))
	|			И (ХозрасчетныйСубконто.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияБухгалтерии.Дебет))
	|ГДЕ
	|	Хозрасчетный.СчетДт В(&СписокСчетов)
	|	И Хозрасчетный.Организация В(&МассивОрганизаций)
	|	И (ХозрасчетныйСубконто.Значение ЕСТЬ NULL
	|			ИЛИ ХозрасчетныйСубконто.Значение = НЕОПРЕДЕЛЕНО
	|			ИЛИ ХозрасчетныйСубконто.Значение = ЗНАЧЕНИЕ(Справочник.ЦенныеБумаги.ПустаяСсылка))
	|	И Хозрасчетный.Активность
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Хозрасчетный.Регистратор,
	|	Хозрасчетный.Организация,
	|	""""
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный КАК Хозрасчетный
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Субконто КАК ХозрасчетныйСубконто
	|		ПО Хозрасчетный.Период = ХозрасчетныйСубконто.Период
	|			И Хозрасчетный.Регистратор = ХозрасчетныйСубконто.Регистратор
	|			И Хозрасчетный.НомерСтроки = ХозрасчетныйСубконто.НомерСтроки
	|			И (ХозрасчетныйСубконто.Вид = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ЦенныеБумаги))
	|			И (ХозрасчетныйСубконто.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияБухгалтерии.Кредит))
	|ГДЕ
	|	Хозрасчетный.СчетКт В(&СписокСчетов)
	|	И Хозрасчетный.Организация В(&МассивОрганизаций)
	|	И (ХозрасчетныйСубконто.Значение ЕСТЬ NULL
	|			ИЛИ ХозрасчетныйСубконто.Значение = НЕОПРЕДЕЛЕНО
	|			ИЛИ ХозрасчетныйСубконто.Значение = ЗНАЧЕНИЕ(Справочник.ЦенныеБумаги.ПустаяСсылка))
	|	И Хозрасчетный.Активность";
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервере
Процедура ТаблицаДокументовПриАктивизацииСтрокиНаСервере(Документ)
	
	НаборЗаписей = РегистрыБухгалтерии.Хозрасчетный.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Регистратор.Значение = Документ;
	НаборЗаписей.Прочитать();
	
	ЗначениеВДанныеФормы(НаборЗаписей, НаборЗаписейХозрасчетный);
	Для Каждого Запись ИЗ НаборЗаписейХозрасчетный Цикл
		Запись.ПодписьДт = НСтр("ru='Дт'");
		Запись.ПодписьКт = НСтр("ru='Кт'");
	КонецЦикла;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередПереходомОкончание(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаписатьИзменения();
		ТаблицаДокументовПриАктивизацииСтрокиНаСервере(Параметры);
	Иначе
		Модифицированность = Ложь;
		ТекущиеДанные = Элементы.ТаблицаДокументов.ТекущиеДанные;
		ТекущийДокумент = ТекущиеДанные.Документ;
		ТаблицаДокументовПриАктивизацииСтрокиНаСервере(ТекущийДокумент);
		УправлениеФормой(ЭтотОбъект);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПередОбновлениемОкончание(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаписатьИзменения();
		ОбновитьНаСервере();
	Иначе
		Модифицированность = Ложь;
		ОбновитьНаСервере();
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Форма.Элементы.Записать.Доступность = Форма.Модифицированность;
	Форма.Элементы.Отменить.Доступность = Форма.Модифицированность;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьИзменения()
	
	СубконтоЦенныеБумаги = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ЦенныеБумаги;
	
	Документ = НаборЗаписейХозрасчетный[0].Регистратор;
	
	НаборЗаписей = РегистрыБухгалтерии.Хозрасчетный.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Регистратор.Значение = Документ;
	НаборЗаписей.Прочитать();
	Для Каждого Проводка ИЗ НаборЗаписей Цикл
		Если СписокСчетов.НайтиПоЗначению(Проводка.СчетДт) <> Неопределено Тогда
			НоваяЦеннаяБумага = НаборЗаписейХозрасчетный[Проводка.НомерСтроки-1].СубконтоДт2;
			Проводка.СубконтоДт.Вставить(СубконтоЦенныеБумаги, НоваяЦеннаяБумага);
		КонецЕсли;
		Если СписокСчетов.НайтиПоЗначению(Проводка.СчетКт) <> Неопределено Тогда
			НоваяЦеннаяБумага = НаборЗаписейХозрасчетный[Проводка.НомерСтроки-1].СубконтоКт2;
			Проводка.СубконтоКт.Вставить(СубконтоЦенныеБумаги, НоваяЦеннаяБумага);
		КонецЕсли;
	КонецЦикла;
	
	НачатьТранзакцию();
	Попытка
		
		НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей, , , Истина);
		
		Если ТипЗнч(Документ) <> Тип("ДокументСсылка.ОперацияБух") Тогда
			МетаданныеДокумента = Документ.Метаданные();
			Если Документ.Метаданные().Реквизиты.Найти("РучнаяКорректировка") <> Неопределено Тогда
				ДокументОбъект = Документ.ПолучитьОбъект();
				ДокументОбъект.РучнаяКорректировка = Истина;
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ДокументОбъект, Истина);
			КонецЕсли;
		КонецЕсли;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ШаблонСообщения = НСтр("ru = 'Не удалось обработать данные документа %1:
			|%2'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, Документ, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
			УровеньЖурналаРегистрации.Ошибка,
			,
			Документ,
			ТекстСообщения);
			
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
	КонецПопытки;

	
	Модифицированность = Ложь;
	ТаблицаДокументовПриАктивизацииСтрокиНаСервере(Документ);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаСервере()
	
	Модифицированность = Ложь;
	ТаблицаДанных = ПолучитьДанныеДокументов();
	ЗначениеВДанныеФормы(ТаблицаДанных, ТаблицаДокументов);
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	
	ХранилищеОбщихНастроек.Сохранить("ПроверкаАналитикиСчетовУчетаКапитала", "НеПроверятьПриНачалеРаботы", НеПроверятьПриНачалеРаботы);
	
КонецПроцедуры

#КонецОбласти

