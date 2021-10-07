﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьРежимВыбора(Параметры.РежимВыбора);
	
	ОтборОрганизация = ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтаФорма);

	Если НЕ ЗначениеЗаполнено(ОтборНалоговыйПериод) Тогда
		УстановитьПериодПоУмолчанию();
	КонецЕсли;
	
	ПредставлениеНалоговогоПериода = ВыборПериодаКлиентСервер.ПолучитьПредставлениеПериодаОтчета(
		Перечисления.ДоступныеПериодыОтчета.Квартал, НачалоКвартала(ОтборНалоговыйПериод), КонецКвартала(ОтборНалоговыйПериод));
		
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "НалоговыйПериод", ОтборНалоговыйПериод, ЗначениеЗаполнено(ОтборНалоговыйПериод));
	
	Если ОтборОрганизация = Справочники.Организации.ПустаяСсылка() Тогда
		ОтборОрганизация = Справочники.Организации.ОрганизацияПоУмолчанию();
		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Организация", ОтборОрганизация, ЗначениеЗаполнено(ОтборОрганизация));
	КонецЕсли; 
	
	УстановитьПараметрыДинамическогоСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОтборОрганизация = ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, ,Параметр);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Организация", ОтборОрганизация, ЗначениеЗаполнено(ОтборОрганизация));
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеНалоговогоПериодаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ИзменитьПериод(ВыбранноеЗначение.НачалоПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеНалоговогоПериодаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка	= Ложь;
	
	ОтборНалоговыйПериод			= '00010101';
	ПредставлениеНалоговогоПериода	= "";
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "НалоговыйПериод", ОтборНалоговыйПериод, ЗначениеЗаполнено(ОтборНалоговыйПериод));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	Оповестить("Запись_ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде", , Элемент.ТекущаяСтрока);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВсеДокументы(Команда)
	Перем Отказ;
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров	= Новый Структура;
	СтруктураПараметров.Вставить("Организация",		ОтборОрганизация);
	СтруктураПараметров.Вставить("НалоговыйПериод",	ОтборНалоговыйПериод);
	СтруктураПараметров.Вставить("ФормироватьКнигуПокупок",				Истина);
	СтруктураПараметров.Вставить("ФормироватьКнигуПродаж",				Истина);
	СтруктураПараметров.Вставить("ФормироватьЖурналУчетаСчетовФактур",	Истина);
	СтруктураПараметров.Вставить("ФормироватьДопЛистыКнигиПокупок",		Истина);
	СтруктураПараметров.Вставить("ФормироватьДопЛистыКнигиПродаж",		Истина);
	
	ТекстВопроса	= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Сформировать документы за %1?'"),
		ПредставлениеНалоговогоПериода);
		
	ОповещениеОтвет = Новый ОписаниеОповещения("ВсеДокументыЗавершение", ЭтотОбъект, СтруктураПараметров);
		
	ПоказатьВопрос(ОповещениеОтвет, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура КнигаПокупок(Команда)
	Перем Отказ;
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров	= Новый Структура;
	СтруктураПараметров.Вставить("Организация",		ОтборОрганизация);
	СтруктураПараметров.Вставить("НалоговыйПериод",	ОтборНалоговыйПериод);
	СтруктураПараметров.Вставить("ФормироватьКнигуПокупок",	Истина);
	
	ТекстВопроса	= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Сформировать Книгу покупок за %1?'"),
		ПредставлениеНалоговогоПериода);
		
	ОповещениеОтвет = Новый ОписаниеОповещения("КнигаПокупокЗавершение", ЭтотОбъект, СтруктураПараметров);
		
	ПоказатьВопрос(ОповещениеОтвет, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура КнигаПродаж(Команда)
	Перем Отказ;
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров	= Новый Структура;
	СтруктураПараметров.Вставить("Организация",		ОтборОрганизация);
	СтруктураПараметров.Вставить("НалоговыйПериод",	ОтборНалоговыйПериод);
	СтруктураПараметров.Вставить("ФормироватьКнигуПродаж",	Истина);
	
	ТекстВопроса	= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Сформировать Книгу продаж за %1?'"),
		ПредставлениеНалоговогоПериода);
		
	ОповещениеОтвет = Новый ОписаниеОповещения("КнигаПродажЗавершение", ЭтотОбъект, СтруктураПараметров);
		
	ПоказатьВопрос(ОповещениеОтвет, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ЖурналУчетаСчетовФактур(Команда)
	Перем Отказ;
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров	= Новый Структура;
	СтруктураПараметров.Вставить("Организация",		ОтборОрганизация);
	СтруктураПараметров.Вставить("НалоговыйПериод",	ОтборНалоговыйПериод);
	СтруктураПараметров.Вставить("ФормироватьЖурналУчетаСчетовФактур",	Истина);
	
	ТекстВопроса	= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Сформировать Журнал учета полученных и выставленных счетов-фактур за %1?'"),
		ПредставлениеНалоговогоПериода);
		
	ОповещениеОтвет = Новый ОписаниеОповещения("ЖурналУчетаСчетовФактурЗавершение", ЭтотОбъект, СтруктураПараметров);
		
	ПоказатьВопрос(ОповещениеОтвет, ТекстВопроса, РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

&НаКлиенте
Процедура ДопЛистКнигиПокупок(Команда)
	Перем Отказ;
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров	= Новый Структура;
	СтруктураПараметров.Вставить("Организация",                     ОтборОрганизация);
	СтруктураПараметров.Вставить("НалоговыйПериод",                 ОтборНалоговыйПериод);
	СтруктураПараметров.Вставить("ФормироватьДопЛистыКнигиПокупок", Истина);
	
	ТекстВопроса	= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Сформировать доп. листы Книги покупок за %1?'"),
		ПредставлениеНалоговогоПериода);
	
	ОповещениеОтвет = Новый ОписаниеОповещения("ДопЛистКнигиПокупокЗавершение", ЭтотОбъект, СтруктураПараметров);
		
	ПоказатьВопрос(ОповещениеОтвет, ТекстВопроса, РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

&НаКлиенте
Процедура ДопЛистКнигиПродаж(Команда)
	Перем Отказ;
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров	= Новый Структура;
	СтруктураПараметров.Вставить("Организация",		ОтборОрганизация);
	СтруктураПараметров.Вставить("НалоговыйПериод",	ОтборНалоговыйПериод);
	СтруктураПараметров.Вставить("ФормироватьДопЛистыКнигиПродаж",	Истина);
	
	ТекстВопроса	= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Сформировать доп. листы Книги продаж за %1?'"),
		ПредставлениеНалоговогоПериода);
	
	ОповещениеОтвет = Новый ОписаниеОповещения("ДопЛистКнигиПродажЗавершение", ЭтотОбъект, СтруктураПараметров);
		
	ПоказатьВопрос(ОповещениеОтвет, ТекстВопроса, РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьРежимВыбора(РежимВыбора)
	
	Элементы.Список.РежимВыбора = РежимВыбора;    
	Элементы.Выбрать.КнопкаПоУмолчанию = РежимВыбора;
	Элементы.Выбрать.Видимость= РежимВыбора;    
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьДокументы(СтруктураПараметров)
	
	ИБФайловая	= СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
	Результат	= СформироватьДокументыНаСервере(СтруктураПараметров, ИБФайловая);
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ПодключатьОбработчикОжидания = НЕ ИБФайловая И ЗначениеЗаполнено(ИдентификаторЗадания);
		Если ПодключатьОбработчикОжидания Тогда
			ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
			ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
		КонецЕсли;
	Иначе
		Если Результат.Свойство("СозданныеДокументы") Тогда
			ОбработатьВыполнениеОперации(Результат);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьДокументыНаСервере(СтруктураПараметров, ИБФайловая)
		
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Документы.ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде.СформироватьДокументыОтчетности(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Формирование документов по учету НДС для передачи в электронном виде'");
		
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"Документы.ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде.СформироватьДокументыОтчетности",
			СтруктураПараметров, 
			НаименованиеЗадания);
		АдресХранилища       = Результат.АдресХранилища;
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
	КонецЕсли;
	
	Если Результат.ЗаданиеВыполнено Тогда
		РезультатОперации	= ОбработатьВыполнениеОперацииНаСервере();
		Результат.Вставить("СозданныеДокументы",		РезультатОперации.СозданныеДокументы);
		Результат.Вставить("ПерезаполненныеДокументы",	РезультатОперации.ПерезаполненныеДокументы);
		Результат.Вставить("УдаленныеДокументы",		РезультатОперации.УдаленныеДокументы);
		Результат.Вставить("Ошибки",					РезультатОперации.Ошибки);
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			РезультатОперации	= ОбработатьВыполнениеОперацииНаСервере();
			ОбработатьВыполнениеОперации(РезультатОперации);
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Функция ОбработатьВыполнениеОперацииНаСервере()
	
	Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьВыполнениеОперации(Результат)
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Документ Из Результат.УдаленныеДокументы Цикл
	
		ТекстОповещения	= НСтр("ru = 'Документ помечен на удаление'");
		ПоказатьОповещениеПользователя(ТекстОповещения, ПолучитьНавигационнуюСсылку(Документ), Строка(Документ));
	
	КонецЦикла;
	
	Для каждого Документ Из Результат.ПерезаполненныеДокументы Цикл
	
		ТекстОповещения	= НСтр("ru = 'Перезаполнен документ'");
		ПоказатьОповещениеПользователя(ТекстОповещения, ПолучитьНавигационнуюСсылку(Документ), Строка(Документ));
	
	КонецЦикла;
	
	Для каждого Документ Из Результат.СозданныеДокументы Цикл
	
		ТекстОповещения	= НСтр("ru = 'Сформирован документ'");
		ПоказатьОповещениеПользователя(ТекстОповещения, ПолучитьНавигационнуюСсылку(Документ), Строка(Документ));
	
	КонецЦикла;
	
	Если Результат.СозданныеДокументы.Количество() + Результат.ПерезаполненныеДокументы.Количество() > 1 Тогда
		ТекстОповещения	= НСтр("ru = 'Документы успешно сформированы'");
		ПоказатьОповещениеПользователя(ТекстОповещения);
	КонецЕсли;
	
	Для каждого ТекстОшибки Из Результат.Ошибки Цикл
	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	
	КонецЦикла;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура ВсеДокументыЗавершение(Результат, СтруктураПараметров) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		СформироватьДокументы(СтруктураПараметров);
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура КнигаПокупокЗавершение(Результат, СтруктураПараметров) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		СформироватьДокументы(СтруктураПараметров);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КнигаПродажЗавершение(Результат, СтруктураПараметров) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		СформироватьДокументы(СтруктураПараметров);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЖурналУчетаСчетовФактурЗавершение(Результат, СтруктураПараметров) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		СформироватьДокументы(СтруктураПараметров);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДопЛистКнигиПокупокЗавершение(Результат, СтруктураПараметров) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		СформироватьДокументы(СтруктураПараметров);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДопЛистКнигиПродажЗавершение(Результат, СтруктураПараметров) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		СформироватьДокументы(СтруктураПараметров);
	КонецЕсли;
	
КонецПроцедуры  

&НаКлиенте
Процедура ПредставлениеНалоговогоПериодаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(ОтборНалоговыйПериод) Тогда
		УстановитьПериодПоУмолчанию();
	КонецЕсли;

	СтандартнаяОбработка = Ложь;
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", 
		ОтборНалоговыйПериод, КонецКвартала(ОтборНалоговыйПериод));
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаКвартал", ПараметрыВыбора, Элементы.ПредставлениеНалоговогоПериода);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПериодПоУмолчанию()
	
	РабочаяДатаПользователя = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Если РабочаяДатаПользователя = НачалоДня(ТекущаяДатаСеанса()) Тогда
		ОтборНалоговыйПериод = НачалоКвартала(ТекущаяДатаСеанса() - 21*24*60*60);
	Иначе
		ОтборНалоговыйПериод = НачалоКвартала(РабочаяДатаПользователя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПериод(НовыйПериод)

	ОтборНалоговыйПериод = НовыйПериод;
	ПредставлениеНалоговогоПериода = ВыборПериодаКлиентСервер.ПолучитьПредставлениеПериодаОтчета(
		ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Квартал"), 
		НачалоКвартала(ОтборНалоговыйПериод),
		КонецКвартала(ОтборНалоговыйПериод));
		
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список,
		"НалоговыйПериод",
		ОтборНалоговыйПериод,
		ЗначениеЗаполнено(ОтборНалоговыйПериод));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыДинамическогоСписка()
	
	Список.Параметры.УстановитьЗначениеПараметра("НадписьДопЛистыКнигиПродаж",     НСтр("ru='Доп. листы книги продаж'"));
	Список.Параметры.УстановитьЗначениеПараметра("НадписьДопЛистКнигиПродаж",      НСтр("ru='Доп. лист книги продаж'"));
	Список.Параметры.УстановитьЗначениеПараметра("НадписьДопЛистыКнигиПокупок",    НСтр("ru='Доп. листы книги покупок'"));
	Список.Параметры.УстановитьЗначениеПараметра("НадписьДопЛистКнигиПокупок",     НСтр("ru='Доп. лист книги покупок'"));
	Список.Параметры.УстановитьЗначениеПараметра("НадписьКнигаПродаж",             НСтр("ru='Книга продаж'"));
	Список.Параметры.УстановитьЗначениеПараметра("НадписьКнигаПокупок",            НСтр("ru='Книга покупок'"));
	Список.Параметры.УстановитьЗначениеПараметра("НадписьЖурналУчетаСчетовФактур", НСтр("ru='Журнал учета счетов-фактур'"));
	
КонецПроцедуры

#КонецОбласти
