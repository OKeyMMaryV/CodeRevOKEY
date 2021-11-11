﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем мПериод Экспорт; // Период движений.

Перем мТаблицаДвижений Экспорт; // Таблица движений.

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 
	
	// В случае если типы значения дополнительных аналитик не совпадают с типами 
	// назначенных измерениям аналитик ставим Неопределено.
	бит_МеханизмДопИзмерений.КонтрольТиповДополнительныАналитик(ЭтотОбъект);
	
	//{ bit SVKushnirenko Bit 27.01.2017 #2657
	пРегистратор = ЭтотОбъект.Отбор.Регистратор.Значение;
	пТипРегистратора = ТипЗнч(пРегистратор);
	пДопСвойства = ЭтотОбъект.ДополнительныеСвойства;
	
	Если 
		пДопСвойства.Свойство("бит_БК_УстановкаСтатусаПередУдалением") И пДопСвойства.бит_БК_УстановкаСтатусаПередУдалением
		Тогда
		
		пНаборЗаписей = РегистрыНакопления.бит_КонтрольныеЗначенияБюджетов.СоздатьНаборЗаписей(); //читаем отдельным объектом, что бы не разрушать текущий контекст
		пНаборЗаписей.Отбор.Регистратор.Значение = пРегистратор;
		пНаборЗаписей.Прочитать();
		
		пТЧНабораЗаписей = пНаборЗаписей.Выгрузить();
		Если пТЧНабораЗаписей.Количество() <>  0 Тогда
					
			бит_БК_Общий.ПопыткаЗакрытияИлиВозвратаСтатусаЗаявокПоДаннымБК(пТЧНабораЗаписей, пРегистратор, "ОтменаПроведения");
		КонецЕсли;
	КонецЕсли;
	//} bit SVKushnirenko Bit 27.01.2017 #2657
	
КонецПроцедуры

//{ bit SVKushnirenko Bit 27.01.2017 #2657
Процедура ПриЗаписи(Отказ, Замещение)
	
	//{Установка статуса после проведения
	пРегистратор = ЭтотОбъект.Отбор.Регистратор.Значение;
	пТипРегистратора = ТипЗнч(пРегистратор);
	пДопСвойства = ЭтотОбъект.ДополнительныеСвойства;
	
	Если 
		пДопСвойства.Свойство("бит_БК_УстановкаСтатусаПослеПроведения") И пДопСвойства.бит_БК_УстановкаСтатусаПослеПроведения
		Тогда
		
		пНаборЗаписей = РегистрыНакопления.бит_КонтрольныеЗначенияБюджетов.СоздатьНаборЗаписей(); //читаем отдельным объектом, что бы не разрушать текущий контекст
		пНаборЗаписей.Отбор.Регистратор.Значение = пРегистратор;
		пНаборЗаписей.Прочитать();
		
		пТЧНабораЗаписей = пНаборЗаписей.Выгрузить();
		Если пТЧНабораЗаписей.Количество() <>  0 Тогда
					
			бит_БК_Общий.ПопыткаЗакрытияИлиВозвратаСтатусаЗаявокПоДаннымБК(пНаборЗаписей.Выгрузить(), пРегистратор, "ПослеПроведения");
		КонецЕсли;
	КонецЕсли;
	//}Установка статуса после проведения
КонецПроцедуры
//} bit SVKushnirenko Bit 27.01.2017 #2657

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ДобавитьДвижение() Экспорт
	
	мТаблицаДвижений.ЗаполнитьЗначения( Истина,  "Активность");

	бит_ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект);
	
КонецПроцедуры // ДобавитьДвижение()

#КонецОбласти

#КонецЕсли
