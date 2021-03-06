
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.Организация = Параметры.Организация;
	Объект.Период      = ПомощникиПоУплатеНалоговИВзносов.ГраницаОтчетностиПрошлыхПериодов(Объект.Организация);
	
	Правило = Параметры.Правило;
	КодЗадачи = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Правило, "Владелец.Код");
	УстановитьЗаголовок();
	
	// Проверка заполненности реквизитов организации, необходимых для уплаты.
	ТекстДействия = НСтр("ru = 'оплатить задолженность за прошлые годы'");
	СообщениеТребуютсяРеквизиты = 
		ПроверкаРеквизитовОрганизации.СтрокаСообщенияНеЗаполненыРеквизитыДляОтчетности(Объект.Организация, ТекстДействия);
	РеквизитыОрганизацииЗаполнены = ПроверитьРеквизитыОрганизации(Объект.Организация).РеквизитыЗаполнены;
	
	ПоказыватьКомандыОплаты = ПомощникиПоУплатеНалоговИВзносов.ПоказыватьКомандыОплаты();
	
	ЗаполнитьЗадолженность();
	
	НайтиИОтобразитьСвязанныеПлатежи();
	
	ЦветПодсветки = ЦветаСтиля.ВыборСтандартногоПериодаФонКнопки;
	
	УстановитьВидимостьКнопокОплаты();
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗапуститьОбновлениеБаннераСостоянияОтправки();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеВыписки" Тогда
		
		ОбработкаОповещенияИзменениеВыписки();
		ЗапуститьОбновлениеБаннераСостоянияОтправки();
		
	ИначеЕсли ИмяСобытия = "Запись_ПлатежныйДокумент_УплатаНалогов" Тогда
		
		Если ТипЗнч(Параметр) = Тип("Структура")
			И Параметр.Свойство("Организация")
			И Параметр.Организация = Объект.Организация Тогда
			
			НайтиИОтобразитьСвязанныеПлатежи();
			УправлениеКомандамиОплаты(ЭтотОбъект);
			
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "Запись_Организации"
		И Объект.Организация = Источник Тогда
		
		РеквизитыОрганизацииЗаполнены = ПроверитьРеквизитыОрганизации(Объект.Организация).РеквизитыЗаполнены;
		УправлениеФормой(ЭтотОбъект);
		
	ИначеЕсли ИмяСобытия = "УдалитьДокументУплаты" Тогда
		
		УдалитьДокументУплаты(Параметр);
		ЗапуститьОбновлениеБаннераСостоянияОтправки();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	РезультатПроверкиРеквизитовОрганизации = ПроверитьРеквизитыОрганизации(Объект.Организация);
	Если НЕ РезультатПроверкиРеквизитовОрганизации.РеквизитыЗаполнены Тогда
		ТекстОписанияОбъектаПроверки = НСтр("ru = 'оплаты задолженности за прошлые годы'");
		ПроверкаРеквизитовОрганизации.СообщитьОбОшибкеЗаполненияРеквизитовДляОтчетности(
			Объект.Организация,
			РезультатПроверкиРеквизитовОрганизации.НезаполненныеРеквизиты,
			"СообщениеТребуютсяРеквизиты",
			Отказ,
			ТекстОписанияОбъектаПроверки)
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СообщениеТребуютсяРеквизитыОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ",                 Объект.Организация);
	ПараметрыФормы.Вставить("Назначение",           "ДляОтчетности");
	ПараметрыФормы.Вставить("ПроверяемыеРеквизиты", ПроверяемыеРеквизитыОрганизации(Объект.Организация));
	
	ОткрытьФорму("Справочник.Организации.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПлатежОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыПлатежныхДокументов = ПомощникиПоУплатеНалоговИВзносовКлиент.ПараметрыОбработкиПлатежныхДокументов(
		Платежи, "Платеж", ОповещениеУдаленияПлатежногоДокумента());
	
	ПомощникиПоУплатеНалоговИВзносовКлиент.ОбработкаНавигационнойСсылкиПлатежногоДокумента(
		Элемент, НавигационнаяСсылкаФорматированнойСтроки, ПараметрыПлатежныхДокументов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаПрошлыхПериодовОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", Объект.Организация);
	ПараметрыФормы.Вставить("Правило",     Правило);
	Оповещение = Новый ОписаниеОповещения("ОпросПомощникаЗавершение", ЭтотОбъект);
	Если КодЗадачи = ЗадачиБухгалтераКлиентСервер.КодЗадачиУСН() Тогда
		ИмяФормыОпросника = "Обработка.МониторНалоговИОтчетности.Форма.ФормаТестПоНалогуЗаПрошлыеПериоды";
	ИначеЕсли КодЗадачи = ЗадачиБухгалтераКлиентСервер.КодЗадачиСтраховыеВзносыИП() Тогда
		ИмяФормыОпросника = "Обработка.МониторНалоговИОтчетности.Форма.ФормаТестПоВзносамЗаПрошлыеПериоды";
		ПараметрыФормы.Вставить("АдресСведенийОбОрганизации", АдресСведенийОбОрганизации(Объект.Организация, УникальныйИдентификатор));
	КонецЕсли;
	ОткрытьФорму(ИмяФормыОпросника, ПараметрыФормы, ЭтотОбъект,,,, Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОплатитьСБанковскогоСчета(Команда)
	
	Оплатить(ПредопределенноеЗначение("Перечисление.СпособыУплатыНалогов.БанковскийПеревод"))
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатитьНаличнымиПоКвитанции(Команда)
	
	Оплатить(ПредопределенноеЗначение("Перечисление.СпособыУплатыНалогов.НаличнымиПоКвитанции"))
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстСостояниеЗагрузкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ИнтеграцияСБанкамиФормыКлиент.ОбработкаНавигационнойСсылкиБаннера(
		ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УправлениеФормой

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Если Форма.ПоказыватьКомандыОплаты Тогда
		Элементы.ГруппаОплатаЗадолженности.Видимость = Истина;
		УправлениеКомандамиОплаты(Форма);
	Иначе
		Элементы.ГруппаОплатаЗадолженности.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.СообщениеТребуютсяРеквизиты.Видимость =
		(ЗначениеЗаполнено(Объект.Организация) И НЕ Форма.РеквизитыОрганизацииЗаполнены);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеКомандамиОплаты(Форма)
	
	Элементы = Форма.Элементы;
	
	ДоступностьКоманд = НЕ ЗадолженностьОплаченаПолностью(Форма);
	
	// Доступность.
	Элементы.ОплатитьСБанковскогоСчета.Доступность    = ДоступностьКоманд;
	Элементы.ОплатитьНаличнымиПоКвитанции.Доступность = ДоступностьКоманд;
	
	УстановитьВидПоУмолчаниюОформлением(Форма, Элементы.ОплатитьСБанковскогоСчета,    ДоступностьКоманд);
	УстановитьВидПоУмолчаниюОформлением(Форма, Элементы.ОплатитьНаличнымиПоКвитанции, ДоступностьКоманд);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКнопокОплаты()
	
	СпособОплаты = ВыполнениеЗадачБухгалтера.СпособУплатыНалогаВзноса(Объект.Организация);
	
	НадоВыбратьСпособОплаты = Не ЗначениеЗаполнено(СпособОплаты);
	
	Элементы.ОплатитьСБанковскогоСчета.Видимость = НадоВыбратьСпособОплаты
		Или (СпособОплаты = Перечисления.СпособыУплатыНалогов.БанковскийПеревод);
	
	Элементы.ОплатитьНаличнымиПоКвитанции.Видимость = НадоВыбратьСпособОплаты
		Или (СпособОплаты = Перечисления.СпособыУплатыНалогов.НаличнымиПоКвитанции);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЗадолженностьОплаченаПолностью(Форма)
	
	Возврат (ИтогоКОплате(Форма) - ОплаченоНалогаВсего(Форма)) <= 0;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИтогоКОплате(Форма)
	
	Если ЭтоЗадачаВзносовИП(Форма.КодЗадачи) Тогда
		ИтогоКОплате = Форма.ПФРИтого + Форма.ФФОМСИтого;
	Иначе
		ИтогоКОплате = Форма.Итого;
	КонецЕсли;
	
	Возврат ИтогоКОплате;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидПоУмолчаниюОформлением(Форма, Элемент, ЭтоКнопкаПоУмолчанию)
	
	Шрифт = Новый Шрифт(Элемент.Шрифт, , , ЭтоКнопкаПоУмолчанию);
	
	Элемент.Шрифт    = Шрифт;
	Элемент.ЦветФона = ?(ЭтоКнопкаПоУмолчанию, Форма.ЦветПодсветки, Новый Цвет);
	
КонецПроцедуры

#КонецОбласти

#Область Заполнение

&НаСервереБезКонтекста
Функция БанковскийСчетОрганизации(Знач Организация)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ОсновнойБанковскийСчет");
	
КонецФункции

&НаСервере
Процедура ЗаполнитьЗадолженность()
	
	ЭтоЗадачаВзносовИП = ЭтоЗадачаВзносовИП(КодЗадачи);
	Элементы.ГруппаНалог.Видимость = Не ЭтоЗадачаВзносовИП;
	Элементы.ГруппаПФР.Видимость   = ЭтоЗадачаВзносовИП;
	Элементы.ГруппаФФОМС.Видимость = ЭтоЗадачаВзносовИП;
	
	ВидыНалогов = Обработки.ПомощникУплатыНалоговВзносовПрошлыхЛет.ВидыНалоговПоКодуЗадачи(Объект.Организация, КодЗадачи);
	НачальныеОстатки = Обработки.ПомощникУплатыНалоговВзносовПрошлыхЛет.НачальныеОстаткиПоНалогам(Объект.Организация, Объект.Период);
	ТаблицаОстатков.Очистить();
	Для Каждого ВидНалога Из ВидыНалогов Цикл
		НайденныеСтроки = НачальныеОстатки.НайтиСтроки(Новый Структура("ВидНалога", ВидНалога));
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			СтрокаОстатков = ТаблицаОстатков.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаОстатков, НайденнаяСтрока);
		КонецЦикла;
	КонецЦикла;
	
	Если ЭтоЗадачаВзносовИП Тогда
		ЗаполнитьРеквизитыСуммВзносов();
	Иначе
		ЗаполнитьРеквизитыСуммНалога();
	КонецЕсли;
	
	// Текст баннера опроса
	БаннерОпроса = Новый Массив;
	ГодЗаголовкаОпроса = Год(КонецГода(Объект.Период) + 1);
	Если Не Обработки.ПомощникУплатыНалоговВзносовПрошлыхЛет.ПройденОпросПоНалогу(Объект.Организация, КодЗадачи)
		И (Итого + ПФРИтого + ФФОМСИтого) = 0 Тогда
		
		Шаблон = СтрШаблон(НСтр("ru = 'Проверьте, нет ли задолженности на начало %1 года.'"),
			Формат(ГодЗаголовкаОпроса, "ЧГ=0"));
		БаннерОпроса.Добавить(Шаблон);
		БаннерОпроса.Добавить(" ");
		БаннерОпроса.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Проверить'"),,,, "ПройтиОпрос"));
	Иначе
		Шаблон = СтрШаблон(НСтр("ru = 'По вашим ответам определена задолженность на начало %1 года.'"),
			Формат(ГодЗаголовкаОпроса, "ЧГ=0"));
		БаннерОпроса.Добавить(Шаблон);
		БаннерОпроса.Добавить(" ");
		БаннерОпроса.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Проверить еще раз'"),,,, "ПройтиОпрос"));
	КонецЕсли;
	ПроверкаПрошлыхПериодов = Новый ФорматированнаяСтрока(БаннерОпроса);
	
КонецПроцедуры

#КонецОбласти

#Область ОтображениеДокументовУплаты

&НаСервере
Процедура ОбработкаОповещенияИзменениеВыписки()
	
	НайтиИОтобразитьСвязанныеПлатежи();
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура НайтиИОтобразитьСвязанныеПлатежи()
	
	Платежи.Очистить();
	
	ЗаполнитьТаблицуПлатежей();
	
	ВывестиПлатежиИБаннерСостоянияОтправкиНаФорму();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПлатежей()
	
	ТаблицаПлатежей = Обработки.ПомощникУплатыНалоговВзносовПрошлыхЛет.ДокументыУплаты(
		Объект.Организация,
		Объект.Период,
		Обработки.ПомощникУплатыНалоговВзносовПрошлыхЛет.ВидыНалоговПоКодуЗадачи(Объект.Организация, КодЗадачи),
		ВидыПлатежей(ЭтоЗадачаВзносовИП(КодЗадачи)));
	
	Если ТаблицаПлатежей <> Неопределено Тогда
		Для Каждого СтрокаТаблицы Из ТаблицаПлатежей Цикл
			ЗаполнитьЗначенияСвойств(Платежи.Добавить(), СтрокаТаблицы);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВывестиПлатежиИБаннерСостоянияОтправкиНаФорму()
	
	СостоянияИнтеграцииДокументов = РегистрыСведений.ДокументыИнтеграцииСБанком.СостоянияИнтеграцииДокументов(
		ДокументыОплаты(ЭтотОбъект));

	ПлатежиДляОтображения = ПомощникиПоУплатеНалоговИВзносов.ПлатежиДляОтображения(
		ЭтотОбъект.Платежи, СостоянияИнтеграцииДокументов);
	ПомощникиПоУплатеНалоговИВзносов.ОтобразитьПлатежи(ЭтотОбъект, ЭтотОбъект.Платежи, "Платеж");
	
	ИнтеграцияСБанкамиФормы.ПолучитьДанныеИПоказатьБаннерСостоянияОтправки(ЭтотОбъект, СостоянияИнтеграцииДокументов);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ХэшДанныхБаннера(Знач ДокументыОплаты)
	
	Возврат ИнтеграцияСБанкамиФормы.ХэшДанныхБаннера(ДокументыОплаты);
	
КонецФункции

&НаКлиенте
Процедура ЗапуститьОбновлениеБаннераСостоянияОтправки()
	Если ИнтервалПроверкиСостоянияИнтеграцииСБанком > 0 Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ЗапуститьОбновлениеБаннераСостояниеОтправки", ИнтервалПроверкиСостоянияИнтеграцииСБанком, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗапуститьОбновлениеБаннераСостояниеОтправки() Экспорт
	
	Документы = Новый Массив;
	Для Каждого Платеж Из Платежи Цикл
		Документы.Добавить(Платеж.Ссылка);
	КонецЦикла;
	Если ХэшДанныхБаннера(Документы) <> ХешДанныхБаннера Тогда
		НайтиИОтобразитьСвязанныеПлатежи();
	КонецЕсли;
	ЗапуститьОбновлениеБаннераСостоянияОтправки();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ДокументыОплаты(Форма)
	
	ДокументыОплаты = Новый Массив;
	
	Для Каждого Платеж Из Форма.Платежи Цикл
		ДокументыОплаты.Добавить(Платеж.Ссылка);
	КонецЦикла;
	
	Возврат ДокументыОплаты;
	
КонецФункции

#КонецОбласти

#Область СозданиеИУдалениеДокументовОплаты

&НаСервере
Функция ОплатитьНаСервере(СпособОплаты)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если СпособОплаты = Перечисления.СпособыУплатыНалогов.БанковскийПеревод Тогда
		
		СчетОрганизации = БанковскийСчетОрганизации(Объект.Организация);
		Если Не ЗначениеЗаполнено(СчетОрганизации) Тогда
			ТекстСообщения = НСтр("ru = 'Укажите банковский счет в реквизитах организации'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Объект.Организация);
			Возврат Неопределено;
		КонецЕсли;
		
	Иначе
		СчетОрганизации = Справочники.БанковскиеСчета.ПустаяСсылка();
	КонецЕсли;
	
	Возврат СоздатьПлатежныеДокументыНаСервере(СпособОплаты, СчетОрганизации);
	
КонецФункции

&НаСервере
Функция СоздатьПлатежныеДокументыНаСервере(СпособОплаты, СчетОрганизации)
	
	СозданныеДокументы = Новый Массив;
	Если ИтогоКОплате(ЭтотОбъект) > 0 Тогда
		
		ТаблицаПлатежей = ТаблицаПлатежейДляФормированияПлатежныхПоручений();
		
		НалоговыйПериод = ?(КодЗадачи = ЗадачиБухгалтераКлиентСервер.КодЗадачиУСН(),
			КонецГода(Объект.Период), НачалоГода(Объект.Период));
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("Правило",         Правило);
		СтруктураПараметров.Вставить("ПериодСобытия",   Объект.Период);
		СтруктураПараметров.Вставить("Организация",     Объект.Организация);
		СтруктураПараметров.Вставить("НалоговыйПериод", НалоговыйПериод);
		СтруктураПараметров.Вставить("Платежи",         ПоместитьВоВременноеХранилище(ТаблицаПлатежей));
		СтруктураПараметров.Вставить("СпособОплаты",    СпособОплаты);
		СтруктураПараметров.Вставить("СчетОрганизации", СчетОрганизации);
		
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СозданныеДокументы,
			Обработки.ФормированиеПлатежныхПорученийНаУплатуНалогов.СоздатьПлатежныеДокументы(СтруктураПараметров));
		
	КонецЕсли;
	
	НайтиИОтобразитьСвязанныеПлатежи();
	
	УправлениеКомандамиОплаты(ЭтотОбъект);
	
	Возврат СозданныеДокументы;
	
КонецФункции

&НаСервере
Функция ТаблицаПлатежейДляФормированияПлатежныхПоручений()

	ТаблицаПлатежей = Обработки.ФормированиеПлатежныхПорученийНаУплатуНалогов.НоваяТаблицаПлатежей();
	Для Каждого СтрокаОстатков Из ТаблицаОстатков Цикл
		Оплачено = ОплаченоПоВидуНалога(Платежи, СтрокаОстатков.ВидНалога, СтрокаОстатков.ВидПлатежаВБюджет);
		КОплате = Макс(0, СтрокаОстатков.Задолженность - Оплачено);
		Если КОплате = 0 Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = ТаблицаПлатежей.Добавить();
		НоваяСтрока.Налог     = СтрокаОстатков.Налог;
		НоваяСтрока.СчетУчета = СтрокаОстатков.СчетУчета;
		НоваяСтрока.Субконто1 = СтрокаОстатков.ВидПлатежаВБюджет;
		НоваяСтрока.Сумма     = КОплате;
	КонецЦикла;
	
	Обработки.ФормированиеПлатежныхПорученийНаУплатуНалогов.ЗаполнитьВидыНалогов(
		ТаблицаПлатежей, Объект.Организация, Объект.Период);
	
	Возврат ТаблицаПлатежей
	
КонецФункции

&НаКлиенте
Функция ОповещениеУдаленияПлатежногоДокумента()
	
	Возврат Новый ОписаниеОповещения("УдалитьДокументУплатыНаКлиентеЗавершение", ЭтотОбъект);
	
КонецФункции

&НаКлиенте
Процедура УдалитьДокументУплатыНаКлиентеЗавершение(ДокументУплатыДляУдаления, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(ДокументУплатыДляУдаления) Тогда
		УдалитьДокументУплаты(ДокументУплатыДляУдаления);
		ЗапуститьОбновлениеБаннераСостоянияОтправки();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьДокументУплаты(ДокументУплатыДляУдаления)
	
	ДокументУплатыОбъект = ДокументУплатыДляУдаления.ПолучитьОбъект();
	ДокументУплатыОбъект.УстановитьПометкуУдаления(Истина);
	
	НайтиИОтобразитьСвязанныеПлатежи();
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ВыполнениеКоманд

&НаКлиенте
Процедура Оплатить(СпособОплаты)
	
	ДокументыОплаты = ОплатитьНаСервере(СпособОплаты);
	УправлениеФормой(ЭтотОбъект);
	
	Если ДокументыОплаты <> Неопределено И ДокументыОплаты.Количество() > 0 Тогда
		ТипСозданныхДокументов = ТипЗнч(ДокументыОплаты[0]);
		ОповеститьОбИзменении(ТипСозданныхДокументов);
		ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.ЗадачиБухгалтера"));
		Оповестить("ИзменилосьСостояниеДокументаИнтеграцииСБанком", Неопределено, ДокументыОплаты);
		ЗапуститьОбновлениеБаннераСостоянияОтправки();
		Оповестить("НалогиПрошлыхПериодов_ИзмененыОстатки",, Объект.Организация);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОплаченоНалогаВсего(Форма)
	
	Результат = 0;
	
	Для Каждого СтрокаПлатежа Из Форма.Платежи Цикл
		Результат = Результат + СтрокаПлатежа.Сумма;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОплаченоПоВидуНалога(КоллекцияПлатежей, ВидНалога, ВидПлатежа)
	
	Отбор = Новый Структура("ВидНалога, ВидНалоговогоОбязательства", ВидНалога, ВидПлатежа);
	НайденныеПлатежи = КоллекцияПлатежей.НайтиСтроки(Отбор);
	
	Результат = 0;
	Для Каждого Платеж Из НайденныеПлатежи Цикл
		Результат = Результат + Платеж.Сумма;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ПроверкаРеквизитовДляОтчетности

&НаСервереБезКонтекста
Функция ПроверитьРеквизитыОрганизации(Организация)
	
	НезаполненныеРеквизиты = Неопределено;
	РеквизитыОрганизацииЗаполнены = ОрганизацииФормыДляОтчетности.РеквизитыЗаполнены(
		Организация, ПроверяемыеРеквизитыОрганизации(Организация), НезаполненныеРеквизиты);
		
	Возврат Новый Структура("РеквизитыЗаполнены, НезаполненныеРеквизиты", РеквизитыОрганизацииЗаполнены, НезаполненныеРеквизиты);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПроверяемыеРеквизитыОрганизации(Организация)
	
	ЭтоЮрлицо = ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоЮрЛицо(Организация);

	Если ЭтоЮрлицо Тогда
		СтрокаРеквизиты = "НаименованиеСокращенное,НаименованиеПолное,ИНН,КПП,КодПоОКТМО";
	Иначе
		СтрокаРеквизиты = "ИНН,ФамилияИП,ИмяИП,Адрес,КодПоОКТМО";
	КонецЕсли;
	СтрокаРеквизиты = СтрЗаменить(СтрокаРеквизиты, " ", "");
	Возврат СтрРазделить(СтрокаРеквизиты, ",", Ложь);
	
КонецФункции

#КонецОбласти

&НаКлиенте
Процедура ОпросПомощникаЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = Неопределено
		Или РезультатЗакрытия = КодВозвратаДиалога.Отмена Тогда
		
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗадолженность();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

Процедура УстановитьЗаголовок()

	Если КодЗадачи = ЗадачиБухгалтераКлиентСервер.КодЗадачиУСН() Тогда
		Заголовок = НСтр("ru = 'УСН, оплата за прошлые годы'");
	ИначеЕсли КодЗадачи = ЗадачиБухгалтераКлиентСервер.КодЗадачиСтраховыеВзносыИП() Тогда
		Заголовок = НСтр("ru = 'Взносы за себя, оплата за прошлые годы'");
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция АдресСведенийОбОрганизации(Организация, УникальныйИдентификатор)

	СведенияОбОрганизации = Обработки.РасчетСтраховыхВзносовИП.СведенияОбОрганизации(
		Организация, ОбщегоНазначения.ТекущаяДатаПользователя());
	Возврат ПоместитьВоВременноеХранилище(СведенияОбОрганизации, УникальныйИдентификатор);

КонецФункции

&НаСервере
Процедура ЗаполнитьРеквизитыСуммНалога()
	
	Налог = 0;
	Пеня  = 0;
	Штраф = 0;
	Итого = 0;
	
	Для Каждого СтрокаОстатков Из ТаблицаОстатков Цикл
		Если СтрокаОстатков.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.Налог Тогда
			Налог = СтрокаОстатков.Задолженность;
		ИначеЕсли СтрокаОстатков.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.ПениСам Тогда
			Пеня = СтрокаОстатков.Задолженность;
		ИначеЕсли СтрокаОстатков.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.Штраф Тогда
			Штраф = СтрокаОстатков.Задолженность;
		КонецЕсли;
		Итого = Итого + СтрокаОстатков.Задолженность;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыСуммВзносов()
	
	ПФРВзнос             = 0;
	ПФРПеня              = 0;
	ПФРШтраф             = 0;
	ПФРВзносСвышеПредела = 0;
	ПФРИтого             = 0;
	
	ФФОМСВзнос = 0;
	ФФОМСПеня  = 0;
	ФФОМСШтраф = 0;
	ФФОМСИтого = 0;
	
	Для Каждого СтрокаОстатков Из ТаблицаОстатков Цикл
		Если СтрокаОстатков.ВидНалога = Перечисления.ВидыНалогов.ФиксированныеВзносы_ПФР_СтраховаяЧасть Тогда
			Если СтрокаОстатков.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.Налог Тогда
				ПФРВзнос = СтрокаОстатков.Задолженность;
			ИначеЕсли СтрокаОстатков.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.ПениСам Тогда
				ПФРПеня = СтрокаОстатков.Задолженность;
			ИначеЕсли СтрокаОстатков.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.Штраф Тогда
				ПФРШтраф = СтрокаОстатков.Задолженность;
			ИначеЕсли СтрокаОстатков.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.ВзносыСвышеПредела Тогда
				ПФРВзносСвышеПредела = СтрокаОстатков.Задолженность;
			КонецЕсли;
			ПФРИтого = ПФРИтого + СтрокаОстатков.Задолженность;
		Иначе
			Если СтрокаОстатков.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.Налог Тогда
				ФФОМСВзнос = СтрокаОстатков.Задолженность;
			ИначеЕсли СтрокаОстатков.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.ПениСам Тогда
				ФФОМСПеня = СтрокаОстатков.Задолженность;
			ИначеЕсли СтрокаОстатков.ВидПлатежаВБюджет = Перечисления.ВидыПлатежейВГосБюджет.Штраф Тогда
				ФФОМСШтраф = СтрокаОстатков.Задолженность;
			КонецЕсли;
			ФФОМСИтого = ФФОМСИтого + СтрокаОстатков.Задолженность;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ВидыПлатежей(ЭтоЗадачаВзносовИП)
	
	Результат = Обработки.ПомощникУплатыНалоговВзносовПрошлыхЛет.ПоддерживаемыеВидыНалоговыхОбязательств();
	Если ЭтоЗадачаВзносовИП Тогда
		Результат.Добавить(Перечисления.ВидыПлатежейВГосБюджет.ВзносыСвышеПредела);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоЗадачаВзносовИП(КодЗадачи)
	
	Возврат КодЗадачи = ЗадачиБухгалтераКлиентСервер.КодЗадачиСтраховыеВзносыИП();
	
КонецФункции

#КонецОбласти
