#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем мКоличествоСубконтоМУ Экспорт; // Хранит количество субконто международного учета в документа.

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события "ОбработкаЗаполнения".
// 
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ПервоначальноеЗаполнениеДокумента();
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события "ПриКопировании".
// 
Процедура ПриКопировании(ОбъектКопирования)
	
	ПервоначальноеЗаполнениеДокумента(ОбъектКопирования);
	
КонецПроцедуры

// Процедура - обработчик события "ПередЗаписью".
// 
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		

	
	// Подсчитаем и запишем сумму документа.
	СуммаДокумента = ДанныеДляНачисления.Итог("СтоимостьНовая");
	
	Если Не Отказ Тогда
		// Выполним синхронизацию пометки на удаление объекта и дополнительных файлов.
		бит_ХранениеДополнительнойИнформации.СинхронизацияПометкиНаУдалениеУДополнительныхФайлов(ЭтотОбъект);
	КонецЕсли; // Если Не Отказ Тогда
	
КонецПроцедуры // ПередЗаписью()
	
Процедура ПриЗаписи(Отказ)
		
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		
	
		
КонецПроцедуры // ПриЗаписи()

// Процедура - обработчик события "ОбработкаПроведения".
// 
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	

	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = бит_ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	// Проверка ручной корректировки.
	Если бит_ОбщегоНазначения.РучнаяКорректировкаОбработкаПроведения(РучнаяКорректировка, Отказ, Заголовок, ЭтотОбъект, Ложь) Тогда
		Возврат
	КонецЕсли;
	
	СтруктураШапкиДокумента = бит_ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	СтруктураТаблиц 		= ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента);	
	
	// ПроверкаДанных(СтруктураШапкиДокумента, СтруктураТаблиц, Отказ, Заголовок);
	
	// Получим курсы валют, неоходимые для выполнения пересчетов.
	ВидыКурсов = Новый Структура("Упр,Регл,МУ,Документ");
	СтруктураКурсыВалют = бит_му_ОбщегоНазначения.ПолучитьСтруктуруКурсовВалют(ЭтотОбъект, СтруктураШапкиДокумента.Дата, ВидыКурсов);
	
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, СтруктураТаблиц, СтруктураКурсыВалют, Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события "ОбработкаУдаленияПроведения".
// 
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	бит_ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, РучнаяКорректировка);
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Процедура обрабатывает изменение валюты документа.
// 
// Параметры:
//  Нет.
// 
Процедура ИзменениеВалютыМодуль() Экспорт

	СтруктураКурса = бит_КурсыВалют.ПолучитьКурсВалюты(ВалютаДокумента, Дата);
	
	КурсДокумента      = СтруктураКурса.Курс;
	КратностьДокумента = СтруктураКурса.Кратность;

КонецПроцедуры // ИзменениеВалютыМодуль()

// Функция готовит таблицы документа для проведения.
// 
// Параметры:
//  СтруктураШапкиДокумента - Структура.
// 
// Возвращаемое значение:
//  СтруктураТаблиц - Структура.
// 
Функция ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТабЧасть.Номенклатура,
	               |	ТабЧасть.Склад,
	               |	ТабЧасть.Количество,
	               |	ТабЧасть.ЕдиницаИзмерения,
	               |	ТабЧасть.СебестоимостьЕдиницы,
	               |	ТабЧасть.Себестоимость,
	               |	ТабЧасть.ЧистаяЦена,
	               |	ТабЧасть.СтоимостьНовая,
	               |	ТабЧасть.СчетУчета,
	               |	ТабЧасть.СчетРезерва,
	               |	ТабЧасть.Резерв,
	               |	ТабЧасть.СчетРасходы,
	               |	ТабЧасть.СубконтоРасходы1,
	               |	ТабЧасть.СубконтоРасходы2,
	               |	ТабЧасть.СубконтоРасходы3,
	               |	ТабЧасть.СубконтоРасходы4,
	               |	ТабЧасть.НомерСтроки
	               |ИЗ
	               |	Документ.бит_му_НачислениеРезерваПоМПЗ.ДанныеДляНачисления КАК ТабЧасть
	               |ГДЕ
	               |	ТабЧасть.Ссылка = &Ссылка";
				   
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаПоДанныеДляНачисления = РезультатЗапроса.Выгрузить();
	
	СтруктураТаблиц = Новый Структура;
	СтруктураТаблиц.Вставить("ДанныеДляНачисления", ТаблицаПоДанныеДляНачисления);
	
	Возврат СтруктураТаблиц;
	
КонецФункции // ПодготовитьТаблицыДокумента()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет первоначальное заполнение созданного/скопированного документа.
// 
// Параметры:
//  ПараметрОбъектКопирования - ДокументОбъект.
// 
Процедура ПервоначальноеЗаполнениеДокумента(ПараметрОбъектКопирования = Неопределено)
	
	бит_ОбщегоНазначения.ЗаполнитьШапкуДокумента(ЭтотОбъект
												,бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь")
												,ПараметрОбъектКопирования);
	
	// Документ не скопирован.
	Если ПараметрОбъектКопирования = Неопределено Тогда
		
		Если Не ЗначениеЗаполнено(ВалютаДокумента) Тогда
			
			// Заполним валюту документа валютой международного учета.
			ВалютаДокумента = бит_му_ОбщегоНазначения.ПолучитьВалютуМеждународногоУчета(Организация,, Ложь);
			
		КонецЕсли; 
		
	КонецЕсли;
	
	ИзменениеВалютыМодуль();
	
КонецПроцедуры // ПервоначальноеЗаполнениеДокумента()

// Процедура выполняет движения по регистрам.
// 
// Параметры:
//  СтруктураШапкиДокумента - Структура.
//  СтруктураТаблиц 		- Структура.
//  СтруктураКурсыВалют 	- Структура.
//  Отказ 					- Булево.
//  Заголовок 				- Строка.
// 
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, СтруктураТаблиц, СтруктураКурсыВалют, Отказ, Заголовок)
	
	ТаблицаДанных = СтруктураТаблиц.ДанныеДляНачисления;
	
	Для Каждого СтрокаТаблицы Из ТаблицаДанных Цикл
		
		// Формируем проводку ДТ СчетРасходы КТ СчетРезерва Себестоимость - СтоимостьНовая.
		СформироватьЗаписьПоДаннымДляНачисления(СтруктураШапкиДокумента, СтрокаТаблицы, СтруктураКурсыВалют, Отказ);
		
	КонецЦикла;
	
КонецПроцедуры // ДвиженияПоРегистрам()

// Процедура формирует движение ДТ СчетРасходы КТ СчетРезерва Себестоимость - СтоимостьНовая.
// 
// Параметры:
//  СтруктураШапкиДокумента - Структура.
// 	СтрокаТаблицы - Строка таблицы значений.
//  СтруктураКурсыВалют 	- Структура.
// 
Процедура СформироватьЗаписьПоДаннымДляНачисления(СтруктураШапкиДокумента, СтрокаТаблицы, СтруктураКурсыВалют, Отказ)
	
	Запись = Движения.бит_Дополнительный_2.Добавить();
	
	// Изменение кода. Начало. 21.04.2016{{
	СуммаПроводки = СтрокаТаблицы.Резерв;
	
	// Если счет расходов в табличной части не указан, то в проводках используется счет расходов из шапки документа.
	СтруктураСчетаРасходов = ?(ЗначениеЗаполнено(СтрокаТаблицы.СчетРасходы), СтрокаТаблицы, СтруктураШапкиДокумента);
	
	// Проверим заполнение счетов
	Если НЕ ПроверитьЗаполнениеРеквизита(СтруктураСчетаРасходов.СчетРасходы, "СчетРасходы", СтрокаТаблицы, Отказ) Тогда
		Возврат;
	КонецЕсли;
	// Изменение кода. Конец. 21.04.2016}}
	
	// Заполнение атрибутов записи.
	СтруктураПараметров = Новый Структура("Организация,Период,Валюта,СчетДт,СчетКт,Сумма,Содержание"
										 ,СтруктураШапкиДокумента.Организация
										 ,СтруктураШапкиДокумента.Дата
										 ,СтруктураШапкиДокумента.ВалютаДокумента
										 ,СтруктураСчетаРасходов.СчетРасходы
										 ,СтрокаТаблицы.СчетРезерва
										 ,СуммаПроводки
										 ,"Начисление резерва по МПЗ");
										 
	бит_му_ОбщегоНазначения.ЗаполнитьЗаписьРегистраМУ(Запись, СтруктураПараметров);											   
	
	// Заполним аналитику счета Дт и Кт.
	Для Н = 1 По мКоличествоСубконтоМУ Цикл
		бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетДт, Запись.СубконтоДт, Н, СтруктураСчетаРасходов["СубконтоРасходы" + Н]);
	КонецЦикла;
	
	бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетДт, Запись.СубконтоДт, "Склады"                         , СтрокаТаблицы.Склад);
	бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетДт, Запись.СубконтоДт, "Номенклатура"                   , СтрокаТаблицы.Номенклатура);
    бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетДт, Запись.СубконтоДт, "ДокументыРасчетовСКонтрагентами", Ссылка);
	// Адаптация для ERP. Начало. 18.03.2014{{
	Если бит_РаботаСМетаданными.ЕстьСправочник("НоменклатурныеГруппы") Тогда
		бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетДт, Запись.СубконтоДт, "НоменклатурныеГруппы", СтрокаТаблицы.Номенклатура.НоменклатурнаяГруппа);
		бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетКт, Запись.СубконтоКт, "НоменклатурныеГруппы", СтрокаТаблицы.Номенклатура.НоменклатурнаяГруппа);
	Иначе
		бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетДт, Запись.СубконтоДт, "НоменклатурныеГруппы", СтрокаТаблицы.Номенклатура.ГруппаФинансовогоУчета);
		бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетКт, Запись.СубконтоКт, "НоменклатурныеГруппы", СтрокаТаблицы.Номенклатура.ГруппаФинансовогоУчета);
	КонецЕсли; 
	// Адаптация для ERP. Конец. 18.03.2014}}
	бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетКт, Запись.СубконтоКт, "Склады"                         , СтрокаТаблицы.Склад);
	бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетКт, Запись.СубконтоКт, "Номенклатура"                   , СтрокаТаблицы.Номенклатура);
    бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетКт, Запись.СубконтоКт, "ДокументыРасчетовСКонтрагентами", Ссылка);
	
	// Выполним валютные пересчеты.
	бит_му_ОбщегоНазначения.ВыполнитьВалютныеПересчетыЗаписи(СтруктураПараметров, Запись, СтруктураКурсыВалют);
	
	Если ЗначениеЗаполнено(СтруктураШапкиДокумента.ДатаСторно) Тогда
	 	
		// Сформируем сторно-проводку
		Запись = Движения.бит_Дополнительный_2.Добавить();
		
		// Изменение кода. Начало. 21.04.2016{{
		СуммаПроводки = -СтрокаТаблицы.Резерв;
		// Изменение кода. Конец. 21.04.2016}}
		
		// Заполнение атрибутов записи.
		СтруктураПараметров = Новый Структура("Организация,Период,Валюта,СчетДт,СчетКт,Сумма,Содержание"
											 ,СтруктураШапкиДокумента.Организация
											 ,СтруктураШапкиДокумента.Дата
											 ,СтруктураШапкиДокумента.ВалютаДокумента
											 ,СтруктураСчетаРасходов.СчетРасходы
											 ,СтрокаТаблицы.СчетРезерва
											 ,СуммаПроводки
											 ,"Сторно начисления резерва по МПЗ");
											 
		бит_му_ОбщегоНазначения.ЗаполнитьЗаписьРегистраМУ(Запись, СтруктураПараметров);											   
		
		// Заполним аналитику счета Дт и Кт.
		Для Н = 1 По мКоличествоСубконтоМУ Цикл
			бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетДт, Запись.СубконтоДт, Н, СтруктураСчетаРасходов["СубконтоРасходы" + Н]);
		КонецЦикла;
		
		бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетДт, Запись.СубконтоДт, "Склады", 				 СтрокаТаблицы.Склад);
		бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетДт, Запись.СубконтоДт, "Номенклатура", 		 СтрокаТаблицы.Номенклатура);
        бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетДт, Запись.СубконтоДт, "ДокументыРасчетовСКонтрагентами", Ссылка);
		// Адаптация для ERP. Начало. 18.03.2014{{
		Если бит_РаботаСМетаданными.ЕстьСправочник("НоменклатурныеГруппы") Тогда
			бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетДт, Запись.СубконтоДт, "НоменклатурныеГруппы", СтрокаТаблицы.Номенклатура.НоменклатурнаяГруппа);
			бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетКт, Запись.СубконтоКт, "НоменклатурныеГруппы", СтрокаТаблицы.Номенклатура.НоменклатурнаяГруппа);
		Иначе
			бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетДт, Запись.СубконтоДт, "НоменклатурныеГруппы", СтрокаТаблицы.Номенклатура.ГруппаФинансовогоУчета);
			бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетКт, Запись.СубконтоКт, "НоменклатурныеГруппы", СтрокаТаблицы.Номенклатура.ГруппаФинансовогоУчета);
		КонецЕсли; 
		// Адаптация для ERP. Конец. 18.03.2014}}
		бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетКт, Запись.СубконтоКт, "Склады", 				 СтрокаТаблицы.Склад);
		бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетКт, Запись.СубконтоКт, "Номенклатура", 		 СтрокаТаблицы.Номенклатура);
        бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетКт, Запись.СубконтоКт, "ДокументыРасчетовСКонтрагентами", Ссылка);
		
		// Выполним валютные пересчеты.
		бит_му_ОбщегоНазначения.ВыполнитьВалютныеПересчетыЗаписи(СтруктураПараметров, Запись, СтруктураКурсыВалют);
		
		Запись.Период = СтруктураШапкиДокумента.ДатаСторно;
	
	КонецЕсли;
	
КонецПроцедуры // СформироватьЗаписьПоДаннымДляНачисления()

// Функция проверяет заполнение реквизита в табличной части.
// 
// Параметры:
//  ЗначениеРеквизита 		- Любой тип.
//  ПредставлениеРеквизита 	- Строка.
// 	СтрокаТаблицы 			- Строка таблицы значений.
//  Отказ 					- Булево.
// 
// Возвращаемое значение:
// 	Результат 				- Булево
// 
Функция ПроверитьЗаполнениеРеквизита(ЗначениеРеквизита, ПредставлениеРеквизита, СтрокаТаблицы, Отказ)

	Результат = Истина;
	
	Если НЕ ЗначениеЗаполнено(ЗначениеРеквизита) Тогда
		МетаданныеРеквизиты 	= Метаданные().ТабличныеЧасти.ДанныеДляНачисления.Реквизиты;
		ПредставлениеРеквизита 	= МетаданныеРеквизиты[ПредставлениеРеквизита].Представление();

		СтрокаСообщения = НСтр("ru = 'Строка номер %1%: Не заполнено значение реквизита ""%2%"".'");
		СтрокаСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(СтрокаСообщения, СокрЛП(СтрокаТаблицы.НомерСтроки), ПредставлениеРеквизита);
		
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(СтрокаСообщения, ЭтотОбъект, , Отказ);
		
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции // ПроверитьЗаполнениеРеквизита() 

#КонецОбласти

#Область Инициализация

мКоличествоСубконтоМУ = 4;

#КонецОбласти

#КонецЕсли
